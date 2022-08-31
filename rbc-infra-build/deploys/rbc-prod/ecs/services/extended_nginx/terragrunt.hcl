#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  ecs_cluster_id = dependency.this_cluster.outputs.ecs_cluster.id
  ecs_cluster_name = dependency.this_cluster.outputs.ecs_cluster.name
  ecs_exec_role_arn = dependency.this_cluster.outputs.ecs_exec_role.arn

  ecs_autoscaling_enabled = true
  ecs_capacity_provider_name = dependency.this_cluster.outputs.capacity_providers.private.ecs_node.name
  ecs_capacity_provider_weight = 1
  ecs_capacity_provider_base = 1

  ecs_desired_replicas    = "1"
  ecs_max_replicas        = "10"
  ecs_min_replicas        = "1"

  ecs_autoscaling_target_cpu_pct = "50"
  ecs_autoscaling_target_mem_pct = "50"
  ecs_autoscaling_scale_in_cooldown = "300"
  ecs_autoscaling_scale_out_cooldown = "300"

  ecs_assign_public_ip = false
  ecs_launch_type      = "EC2"
  ecs_network_mode     = "bridge"

  lb_target_group_arn = dependency.this_lb.outputs.lb_targets["web"].arn
  lb_health_check_grace_period_seconds = 10

  route53_create_alias = false

  security_group_ids = [
    dependency.this_sg.outputs.security_group.id
  ]

  storage_key_arn = dependency.this_kms.outputs.storage_key.arn
  secrets_key_arn = dependency.this_kms.outputs.secrets_key.arn

  s3_bucket_arns = [
    dependency.this_s3.outputs.buckets.main.arn
  ]

  subnet_ids = dependency.this_vpc.outputs.subnet_ids
  vpc_id = dependency.this_vpc.outputs.vpc.id

  # --------------------------------------------------------------------------------------------------------------------

  ecs_cpu_units   = ""
  ecs_memory_mib  = ""

  container_cpu_units   = "256"
  container_memory_mib  = "512"

  sidecar_cpu_units   = "256"
  sidecar_memory_mib  = "256"

  # --------------------------------------------------------------------------------------------------------------------

  container_image = "738001968068.dkr.ecr.ca-central-1.amazonaws.com/saas_extended:php-v1.18.05-c74fd96"
  container_name = "extended-php"
  container_command = ["/bin/sh", "/usr/local/bin/entrypoint.sh"]
  container_working_directory = "/srv"
  container_port_mappings = [
    {
      protocol      = "tcp"
      containerPort = "9000"
      hostPort      = "0"
    },
  ]

  container_environment = [
    {
      name = "APP_DEBUG"
      value = "true"
    },
    {
      name = "APP_ENV"
      value = "production"
    },
    {
      name = "APP_LOGS"
      value = "Daily"
    },
    {
      name = "APP_REQUEST_LOGS"
      value = "false"
    },
    {
      name = "APP_TIMEZONE"
      value = "UTC"
    },
    {
      name = "AWS_BUCKET"
      value = "prod-infra-rbc-bucket"
    },
    {
      name = "AWS_DEFAULT_REGION"
      value = "ca-central-1"
    },
    {
      name = "AWS_URL"
      value = ""
    },
    {
      name = "BROADCAST_DRIVER"
      value = "redis"
    },
    {
      name = "CACHE_DRIVER"
      value = "redis"
    },
    {
      name = "CONTAINER_NAME"
      value = "extended-php"
    },
    {
      name = "DB_CONNECTION"
      value = "mysql"
    },
    {
      name = "DB_DATABASE"
      value = "extended"
    },
    {
      name = "DB_LOGS_CONNECTION"
      value = "logs"
    },
    {
      name = "DB_LOGS_DATABASE"
      value = "extended_logs"
    },
    {
      name = "DB_LOGS_PORT"
      value = "3306"
    },
    {
      name = "DB_PORT"
      value = "3306"
    },
    {
      name = "DB_USERNAME"
      value = "extended"
    },
    {
      name = "LOG_ALL_HTTP_REQUEST"
      value = "true"
    },
    {
      name = "LOG_CHANNEL"
      value = "stack"
    },
    {
      name = "LOG_SLACK_WEBHOOK_URL"
      value = ""
    },
    {
      name = "NEW_RELIC_APP_NAME"
      value = ""
    },
    {
      name = "NEW_RELIC_LICENSE"
      value = ""
    },
    {
      name = "QUEUE_CONNECTION"
      value = "redis"
    },
    {
      name = "TELESCOPE_DB_CHUNK"
      value = "100"
    },
    {
      name = "TELESCOPE_DB_CONNECTION"
      value = "logs"
    },
    {
      name = "TELESCOPE_ENABLED"
      value = "false"
    },
  ]

  container_secrets = [
    {
      name = "APP_KEY",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/app_key"]
    },
    {
      name = "AWS_ACCESS_KEY_ID",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/AWS_ACCESS_KEY_ID"]
    },
    {
      name = "AWS_SECRET_ACCESS_KEY",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/AWS_SECRET_ACCESS_KEY"]
    },
    {
      name = "DB_HOST",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/extended/db_host"],
    },
    {
      name = "DB_LOGS_HOST",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/extended/db_host"],
    },
    {
      name = "DB_LOGS_PASSWORD",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/extended/db_password"],
    },
    {
      name = "DB_PASSWORD",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/extended/db_password"],
    },
    {
      name = "REDIS_HOST",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/redis_host"],
    },
  ]

  # --------------------------------------------------------------------------------------------------------------------

  sidecar_image = "738001968068.dkr.ecr.ca-central-1.amazonaws.com/saas_extended:nginx-v1.18.05-c74fd96"
  sidecar_name = "extended-nginx"
  sidecar_command = [ ]
  sidecar_working_directory = "/srv"
  sidecar_port_mappings = [
    {
      protocol      = "tcp"
      containerPort = "80"
      hostPort      = "0"
    },
  ]

  sidecar_environment = [
    {
      name = "CONTAINER_NAME"
      value = "extended-nginx"
    }
  ]

  sidecar_secrets = [

  ]

  sidecar_depends_on = [{
    containerName = "extended-php"
    condition = "START"
  }]
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_cluster" {
  config_path = "../../..//ecs/cluster"
}

dependency "this_kms" {
  config_path = "../../..//kms"
}

dependency "this_lb" {
  config_path = "../../..//ec2/load_balancers/extended_nginx"
}

dependency "this_s3" {
  config_path = "../../..//s3"
}

dependency "this_secrets" {
  config_path = "../../..//secrets"
}

dependency "this_sg" {
  config_path = "../../..//ec2/security_groups/extended_nginx/svc"
}

dependency "this_vpc" {
  config_path = "../../..//vpc/network"
}

locals {
  #
  # Common configurables (may reference local.defaults)
  #
  variables = {
    label = {
      name = "extended-nginx"
    }
  }

  ##
  ## NOTE -- Try not to modify locals below this point, we're merging values to be inherited
  ##

  #
  # Common initialization of variables with defaults
  #
  defaults = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs

  _variables = {
    for k in keys(local.defaults) :
    k => merge(
      lookup(local.defaults, k, {}),
      lookup(local.variables, k, {})
    )
  }

  _defaults = {
    aws = {
      role_arn = lookup(
        local._variables.aws, "role_arn",
        "arn:aws:iam::738001968068:role/prod-infra-rbc-terraform"
      )
    }
  }

  #
  # Output merged configuration object
  #
  config = {
    for k in distinct(concat(keys(local.defaults), keys(local.variables))) :
    k => merge(
      lookup(local.defaults, k, {}),
      lookup(local._defaults, k, {}),
      lookup(local.variables, k, {})
    )
  }
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../..//modules/ecs/services/ec2_sidecar"
}
