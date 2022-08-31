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

  lb_target_group_arn = dependency.this_lb.outputs.lb_targets["web"].arn
  lb_health_check_grace_period_seconds = 10

  security_group_ids = [
    dependency.this_sg.outputs.security_group.id
  ]

  storage_key_arn = dependency.this_kms.outputs.storage_key.arn

  subnet_ids = dependency.this_vpc.outputs.subnet_ids
  vpc_id = dependency.this_vpc.outputs.vpc.id

  container_image = "738001968068.dkr.ecr.ca-central-1.amazonaws.com/desjardins-staging-loyalty-maintenance:desjardins-3"
  container_command = [ ]
  container_port_mappings = [
    {
      protocol      = "tcp"
      containerPort = "80"
      hostPort      = "80"
    },
  ]

  ecs_cpu_units   = "512"
  ecs_memory_mib  = "1024"

  ecs_desired_replicas    = "1"
  ecs_max_replicas        = "1"
  ecs_min_replicas        = "1"

  ecs_autoscaling_target_cpu_pct = "50"
  ecs_autoscaling_target_mem_pct = "50"
  ecs_autoscaling_scale_in_cooldown = "300"
  ecs_autoscaling_scale_out_cooldown = "300"

  ecs_assign_public_ip = true
  ecs_launch_type      = "FARGATE"
  ecs_network_mode     = "awsvpc"
  ecs_platform_version = "1.4.0"

  container_environment = [

  ]

  container_secrets = [

  ]

  efs_volumes = [

  ]
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
  config_path = "../../..//ec2/load_balancers/maintenance"
}

dependency "this_sg" {
  config_path = "../../..//ec2/security_groups/maintenance/svc"
}

dependency "this_ssm_parameters" {
  config_path = "../../..//ssm/parameters"
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
      name = "maint"
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
      role_arn = lookup(local._variables.aws, "role_arn",
        format("arn:aws:iam::%s:role/%s-%s",
          local._variables.aws.account_id,
          lookup(local._variables.label, "stage_prefix", format("%s-%s",
            local._variables.label.namespace,
            local._variables.label.stage,
          )),
          local._variables.aws.role_suffix
        )
      )
    }
    label = {
      stage_prefix = format("%s-%s",
        local._variables.label.namespace,
        local._variables.label.stage,
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
  source = "../../../../..//modules/ecs/services/fargate"
}
