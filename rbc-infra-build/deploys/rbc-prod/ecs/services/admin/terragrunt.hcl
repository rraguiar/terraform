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

  lb_target_group_arn = dependency.this_lb.outputs.lb_targets["web"].arn
  lb_health_check_grace_period_seconds = 10

  route53_create_alias = true
  route53_zone_id = "Z1TWO1QSRGJC91"
  route53_fqdn = "rbc-admin.podiumrewards.com"
  route53_alias_fqdn = dependency.this_lb.outputs.lb.fqdn
  route53_alias_zone_id = dependency.this_lb.outputs.lb.zone_id

  security_group_ids = [
    dependency.this_sg.outputs.security_group.id
  ]

  s3_environment_files = [
    {
      value = format("%s/.env", dependency.this_s3.outputs.buckets.main.arn)
      type  = "s3"
    },
  ]
  s3_bucket_arns = [
    dependency.this_s3.outputs.buckets.main.arn
  ]

  secrets_key_arn = dependency.this_kms.outputs.secrets_key.arn
  storage_key_arn = dependency.this_kms.outputs.storage_key.arn

  subnet_ids = dependency.this_vpc.outputs.subnet_ids
  vpc_id = dependency.this_vpc.outputs.vpc.id

  # --------------------------------------------------------------------------------------------------------------------

  container_image = "738001968068.dkr.ecr.ca-central-1.amazonaws.com/saas_podium:rbc-admin-uat-1.0.33"
  container_command = [ ]
  container_working_directory = "/usr/share/nginx/html"
  container_port_mappings = [
    {
      protocol      = "tcp"
      containerPort = "3001"
      hostPort      = "0"
    },
  ]

  ecs_cpu_units   = "256"
  ecs_memory_mib  = "512"

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

  network_configurations = []
  container_environment = []
  container_secrets = []
  efs_volume_config = []
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
  config_path = "../../..//ec2/load_balancers/admin"
}

dependency "this_s3" {
  config_path = "../../..//s3"
}

dependency "this_sg" {
  config_path = "../../..//ec2/security_groups/admin/svc"
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
      name = "admin"
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
  source = "../../../../..//modules/ecs/services/ec2"
}
