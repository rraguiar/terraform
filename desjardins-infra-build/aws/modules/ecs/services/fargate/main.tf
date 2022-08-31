#
# IAM Task role
#
module "task_role" {
  source = "../../../../resources/aws_iam/role_assumeable"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  principals = {
    aws = [
      var.ecs_exec_role_arn
    ],
    service = [
      "ecs-tasks.amazonaws.com",
      "ecs.application-autoscaling.amazonaws.com"
    ]
  }

  policy_map = {
    Autoscaling = data.aws_iam_policy_document.ecs_autoscaling_policy.json,
    EcsTasks    = data.aws_iam_policy_document.ecs_tasks_policy.json,
    KmsUsage    = data.aws_iam_policy_document.ecs_kms_policy.json,
    EcsExec     = data.aws_iam_policy_document.ecs_exec_policy.json,
  }
}

data "aws_iam_policy_document" "ecs_tasks_policy" {
  statement {
    sid       = "AllowEcsTasksAssumeRole"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_kms_policy" {
  statement {
    sid = "AllowStorageKmsUsage"

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]

    resources = [
      var.storage_key_arn
    ]
  }
}

data "aws_iam_policy_document" "ecs_autoscaling_policy" {
  statement {
    sid = "AllowAutoscaling"

    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DeleteAlarms"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "ecs_exec_policy" {
  statement {
    sid = "AllowEcsExec"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = [
      "*"
    ]
  }
}

#
# ECS
#
module "ecs_service" {
  source = "../../../../resources/aws_ecs/service/fargate"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  container_image         = var.container_image
  container_name          = var.label.name
  container_command       = var.container_command
  container_port_mappings = var.container_port_mappings
  container_environment   = var.container_environment
  container_secrets       = var.container_secrets

  ecs_region           = var.aws.region
  ecs_subnets          = var.lb_internal ? var.subnet_ids.private : var.subnet_ids.public
  ecs_cluster_id       = var.ecs_cluster_id
  ecs_assign_public_ip = var.ecs_assign_public_ip
  ecs_network_mode     = var.ecs_network_mode

  ecs_exec_role_arn    = var.ecs_exec_role_arn
  ecs_task_role_arn    = module.task_role.arn
  ecs_launch_type      = var.ecs_launch_type
  ecs_platform_version = var.ecs_platform_version

  ecs_cpu_units        = var.ecs_cpu_units
  ecs_memory_mib       = var.ecs_memory_mib
  ecs_desired_replicas = var.ecs_desired_replicas

  ecs_readonly_root_filesystem = var.ecs_readonly_root_filesystem

  efs_volumes = var.efs_volumes

  lb_target_group_arn                  = var.lb_target_group_arn
  lb_health_check_grace_period_seconds = var.lb_health_check_grace_period_seconds

  linux_parameters = var.linux_parameters

  security_group_ids = var.security_group_ids

  vpc_id = var.vpc_id
}

#
# Autoscaling
#
resource "aws_appautoscaling_target" "this" {
  max_capacity       = var.ecs_max_replicas
  min_capacity       = var.ecs_min_replicas
  resource_id        = format("service/%s/%s", var.ecs_cluster_name, var.label.name)
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [module.ecs_service]
}

resource "aws_appautoscaling_policy" "this-cpu" {
  name               = format("%s-autoscaling-cpu", var.label.name)
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.ecs_autoscaling_target_cpu_pct
    scale_in_cooldown  = var.ecs_autoscaling_scale_in_cooldown
    scale_out_cooldown = var.ecs_autoscaling_scale_out_cooldown
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }

  depends_on = [aws_appautoscaling_target.this]
}

resource "aws_appautoscaling_policy" "this-mem" {
  name               = format("%s-autoscaling-mem", var.label.name)
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.ecs_autoscaling_target_mem_pct
    scale_in_cooldown  = var.ecs_autoscaling_scale_in_cooldown
    scale_out_cooldown = var.ecs_autoscaling_scale_out_cooldown
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }

  depends_on = [aws_appautoscaling_target.this]
}
