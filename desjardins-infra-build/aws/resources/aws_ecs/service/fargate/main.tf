locals {
  ecs_log_group = format("/ecs/%s-%s-%s", var.namespace, var.environment, var.name)
  mount_points = [for k, v in var.efs_volumes :
    {
      containerPath = var.efs_volumes[k].container_path
      sourceVolume  = var.efs_volumes[k].name
    }
  ]
}

module "label" {
  source = "../../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

#
# Task Definition
#
resource "aws_ecs_task_definition" "this" {
  tags = module.label.tags

  family                   = format("%s-%s-%s", var.namespace, var.environment, var.name)
  requires_compatibilities = [var.ecs_launch_type]
  network_mode             = var.ecs_network_mode
  cpu                      = var.ecs_cpu_units
  memory                   = var.ecs_memory_mib
  execution_role_arn       = var.ecs_exec_role_arn
  task_role_arn            = var.ecs_task_role_arn

  dynamic "volume" {
    for_each = var.efs_volumes
    iterator = efs

    content {
      name = efs.value.name

      efs_volume_configuration {
        file_system_id = efs.value.volume_config.file_system_id
        root_directory = efs.value.volume_config.root_directory
      }
    }
  }

  container_definitions = "[${module.main_container.json_map_encoded}]"
}

#
# Container Definition
#
module "main_container" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=0.55.0"

  container_image = var.container_image
  container_name  = var.container_name
  command         = var.container_command

  environment = var.container_environment
  secrets     = var.container_secrets

  linux_parameters = var.linux_parameters

  log_configuration = {
    logDriver = "awslogs",
    options = {
      awslogs-group         = local.ecs_log_group,
      awslogs-region        = var.ecs_region,
      awslogs-stream-prefix = "ecs"
    }
  }

  mount_points             = local.mount_points
  readonly_root_filesystem = var.ecs_readonly_root_filesystem

  port_mappings = var.container_port_mappings
}

#
# CloudWatch log group
#
resource "aws_cloudwatch_log_group" "this" {
  name = local.ecs_log_group
  tags = module.label.tags

  retention_in_days = 14
}

#
# Service - awsvpc (ie. Fargate)
# -- 'awsvpc' network mode requires the 'network_configuration' block
#
resource "aws_ecs_service" "this" {
  name = var.name
  tags = var.tags

  cluster          = var.ecs_cluster_id
  launch_type      = var.ecs_launch_type
  platform_version = var.ecs_platform_version
  task_definition  = aws_ecs_task_definition.this.arn
  desired_count    = var.ecs_desired_replicas

  health_check_grace_period_seconds = var.lb_health_check_grace_period_seconds

  enable_ecs_managed_tags = var.enable_ecs_managed_tags
  propagate_tags          = var.propagate_tags

  network_configuration {
    assign_public_ip = var.ecs_assign_public_ip
    security_groups  = var.security_group_ids
    subnets          = var.ecs_subnets
  }

  dynamic "load_balancer" {
    for_each = var.container_port_mappings
    iterator = cpm

    content {
      target_group_arn = var.lb_target_group_arn
      container_name   = var.container_name
      container_port   = cpm.value.containerPort
    }
  }

  # ignore autoscaling and deployments
  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }
}
