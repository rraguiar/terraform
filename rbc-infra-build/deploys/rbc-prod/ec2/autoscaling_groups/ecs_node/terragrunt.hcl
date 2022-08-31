#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  ami_name = "Final-ECS-HARDENED-IMAGE-*"
  ami_instance_type = "t3.xlarge"
  ami_owners = [
    "738001968068"
  ]

  target_capacity = {
    private = {
      min = 1,
      max = 10
    },
    public = {
      min = 0,
      max = 0
    },
  }

  security_group_rules_private = {
    vpc = {
      protocol   = "all"
      type       = "ingress"
      from_port  = "0"
      to_port    = "65535"
      cidr_block = "10.100.0.0/16"
    },
  }

  subnet_ids = dependency.this_vpc.outputs.subnet_ids
  vpc_id = dependency.this_vpc.outputs.vpc.id
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_vpc" {
  config_path = "../../..//vpc/network"
}

locals {
  #
  # Common configurables (may reference local.defaults)
  #
  variables = {
    label = {
      name = "ecs-node"
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
  source = "../../../../..//modules/ec2/autoscaling_groups"
}
