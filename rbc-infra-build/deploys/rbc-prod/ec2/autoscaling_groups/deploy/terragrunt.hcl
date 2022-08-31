#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  ami_name = "prod-infra-rbc-deploy-*"
  ami_instance_type = "t3.medium"
  ami_owners = [
    "738001968068"
  ]

  target_capacity = {
    private = {
      min = 0,
      max = 0
    },
    public = {
      min = 0,
      max = 1
    },
  }

  security_group_rules_public = {
    ssh = {
      protocol   = "tcp"
      type       = "ingress"
      from_port  = "22"
      to_port    = "22"
      cidr_block = "0.0.0.0/0"
    },
    mysql = {
      protocol   = "tcp"
      type       = "ingress"
      from_port  = "3306"
      to_port    = "3306"
      cidr_block = "0.0.0.0/0"
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
      name = "deploy"
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
