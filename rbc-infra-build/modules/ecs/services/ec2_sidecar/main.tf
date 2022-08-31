#
# ECS / Service
#
module "ecs_service" {
  source = "../../../../resources/aws_ecs/service/ec2_sidecar"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  capacity_provider_name   = var.ecs_capacity_provider_name
  capacity_provider_weight = var.ecs_capacity_provider_weight
  capacity_provider_base   = var.ecs_capacity_provider_base

  container_image             = var.container_image
  container_name              = var.container_name
  container_command           = var.container_command
  container_port_mappings     = var.container_port_mappings
  container_environment       = var.container_environment
  container_secrets           = var.container_secrets
  container_working_directory = var.container_working_directory

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
  container_cpu_units  = var.container_cpu_units
  container_memory_mib = var.container_memory_mib

  ecs_desired_replicas = var.ecs_desired_replicas

  efs_volume_config = var.efs_volume_config

  lb_target_group_arn               = var.lb_target_group_arn
  health_check_grace_period_seconds = var.lb_health_check_grace_period_seconds

  linux_parameters        = var.linux_parameters
  docker_security_options = var.docker_security_options
  network_configurations  = var.network_configurations

  s3_environment_files = var.s3_environment_files

  security_group_ids = var.security_group_ids
  vpc_id             = var.vpc_id

  # Sidecar container

  sidecar_image             = var.sidecar_image
  sidecar_name              = var.sidecar_name
  sidecar_command           = var.sidecar_command
  sidecar_port_mappings     = var.sidecar_port_mappings
  sidecar_environment       = var.sidecar_environment
  sidecar_secrets           = var.sidecar_secrets
  sidecar_working_directory = var.sidecar_working_directory

  sidecar_cpu_units        = var.sidecar_cpu_units
  sidecar_memory_mib       = var.sidecar_memory_mib

  sidecar_depends_on = var.sidecar_depends_on
}

#
# Autoscaling
#
resource "aws_appautoscaling_target" "this" {
  count = var.ecs_autoscaling_enabled == true ? 1 : 0

  max_capacity       = var.ecs_max_replicas
  min_capacity       = var.ecs_min_replicas
  resource_id        = format("service/%s/%s", var.ecs_cluster_name, module.ecs_service.ecs_service.name)
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [module.ecs_service]
}

resource "aws_appautoscaling_policy" "this-cpu" {
  count = var.ecs_autoscaling_enabled == true ? 1 : 0

  name               = format("%s-autoscaling-cpu", var.label.name)
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this[0].resource_id
  scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.ecs_autoscaling_target_cpu_pct
    scale_in_cooldown  = var.ecs_autoscaling_scale_in_cooldown
    scale_out_cooldown = var.ecs_autoscaling_scale_out_cooldown
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }

  depends_on = [aws_appautoscaling_target.this[0]]
}

resource "aws_appautoscaling_policy" "this-mem" {
  count = var.ecs_autoscaling_enabled == true ? 1 : 0

  name               = format("%s-autoscaling-mem", var.label.name)
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this[0].resource_id
  scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.ecs_autoscaling_target_mem_pct
    scale_in_cooldown  = var.ecs_autoscaling_scale_in_cooldown
    scale_out_cooldown = var.ecs_autoscaling_scale_out_cooldown
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }

  depends_on = [aws_appautoscaling_target.this[0]]
}
