locals {
  ecs_log_group = format("/ecs/%s-%s-%s", var.environment, var.name, var.stage)

  load_balancer_configs = (
    var.lb_target_group_arn == null ?
    [] :
    [{
      target_group_arn = var.lb_target_group_arn
      container_name   = format("%s-%s-%s", var.environment, var.name, var.stage)
      container_port   = var.container_port_mappings[0].containerPort
    }]
  )

  mount_points = (var.efs_volume_config == [] ?
    [] :
    [for volume in var.efs_volume_config : {
      containerPath = volume.mount_point
      sourceVolume  = volume.name
      readOnly      = volume.readonly
    }]
  )
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

  family                   = format("%s-%s-%s", var.environment, var.name, var.stage)
  requires_compatibilities = [var.ecs_launch_type]
  network_mode             = var.ecs_network_mode
  cpu                      = var.ecs_cpu_units
  memory                   = var.ecs_memory_mib
  execution_role_arn       = var.ecs_exec_role_arn
  task_role_arn            = var.ecs_task_role_arn

  dynamic "volume" {
    for_each = var.efs_volume_config
    iterator = efs

    content {
      name = lookup(efs.value, "name", "efs")

      efs_volume_configuration {
        file_system_id          = efs.value.file_system_id
        root_directory          = lookup(efs.value, "root_directory", "/")
        transit_encryption      = lookup(efs.value, "transit_encryption", "DISABLED")
        transit_encryption_port = lookup(efs.value, "transit_encryption_port", null)

        authorization_config {
          access_point_id = lookup(efs.value, "access_point_id", null)
          iam             = lookup(efs.value, "iam", "DISABLED")
        }
      }
    }
  }

  container_definitions = "[${module.main_container.json_map_encoded}]"
}

#
# Container Definition
#
module "main_container" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=0.45.0"

  container_image   = var.container_image
  container_name    = format("%s-%s-%s", var.environment, var.name, var.stage)
  command           = var.container_command
  environment       = var.container_environment
  secrets           = var.container_secrets
  working_directory = var.container_working_directory

  container_memory_reservation = var.ecs_memory_mib
  container_cpu                = var.ecs_cpu_units

  port_mappings = var.container_port_mappings
  mount_points  = local.mount_points

  log_configuration = {
    logDriver = "awslogs",
    options = {
      awslogs-group         = local.ecs_log_group,
      awslogs-region        = var.ecs_region,
      awslogs-stream-prefix = "ecs"
    }
  }

  linux_parameters        = var.linux_parameters
  docker_security_options = var.docker_security_options
  environment_files       = var.s3_environment_files
}

#
# CloudWatch log group
#
resource "aws_cloudwatch_log_group" "this" {
  name = local.ecs_log_group
  tags = module.label.tags

  retention_in_days = 14
}

resource "aws_ecs_service" "this" {
  name = module.label.id
  tags = var.tags

  cluster          = var.ecs_cluster_id
  platform_version = var.ecs_platform_version
  task_definition  = aws_ecs_task_definition.this.arn
  desired_count    = var.ecs_desired_replicas

  health_check_grace_period_seconds = (
    var.lb_target_group_arn == null ? null : var.health_check_grace_period_seconds
  )

  enable_ecs_managed_tags = var.enable_ecs_managed_tags
  propagate_tags          = var.propagate_tags

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = var.capacity_provider_weight
    base              = var.capacity_provider_base
  }

  dynamic "load_balancer" {
    for_each = local.load_balancer_configs
    iterator = lbc

    content {
      target_group_arn = lbc.value.target_group_arn
      container_name   = lbc.value.container_name
      container_port   = lbc.value.container_port
    }
  }

  dynamic "network_configuration" {
    for_each = var.network_configurations
    iterator = nc

    content {
      assign_public_ip = var.ecs_assign_public_ip
      security_groups  = var.security_group_ids
      subnets          = var.ecs_subnets
    }
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  # ignore autoscaling and deployments
  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }
}

