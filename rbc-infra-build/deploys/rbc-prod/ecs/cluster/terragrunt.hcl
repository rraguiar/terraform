#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  secrets_key_arn = dependency.this_kms.outputs.secrets_key.arn
  storage_key_arn = dependency.this_kms.outputs.storage_key.arn

  s3_bucket_arns = [
    dependency.this_s3.outputs.buckets.main.arn
  ]

  # ASG / private
  asg_arns_private = {
    ecs_node = dependency.this_asg_ecs_node.outputs.asg.private.autoscaling_group.arn,
  }

  # ASG / public
  asg_arns_public = {
    ecs_node = dependency.this_asg_ecs_node.outputs.asg.public.autoscaling_group.arn,
  }

  # Target Capacity

  # see: https://aws.amazon.com/blogs/containers/deep-dive-on-amazon-ecs-cluster-auto-scaling/
  # CapacityProviderReservation =  M / N x 100, where M = instances needed, and N = instances running

  # private 
  target_capacity_private = {
    ecs_node = 100
  }

  # public
  target_capacity_public = {
    ecs_node = 100
  }
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_asg_ecs_node" {
  config_path = "../..//ec2/autoscaling_groups/ecs_node"
}

dependency "this_kms" {
  config_path = "../..//kms"
}

dependency "this_s3" {
  config_path = "../..//s3"
}

dependency "this_vpc" {
  config_path = "../..//vpc/network"
}

locals {
  #
  # Common configurables (may reference local.defaults)
  #
  variables = {
    label = {
      name = "ecs-cluster"
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
  source = "../../../..//modules/ecs/cluster"
}
