#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  subnet_ids = dependency.this_vpc.outputs.subnet_ids
  vpc_id = dependency.this_vpc.outputs.vpc.id

  security_group_rules = {
    http = {
      protocol   = "tcp"
      type       = "ingress"
      from_port  = "80"
      to_port    = "80"
      cidr_block = "0.0.0.0/0"
    },
  }
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_vpc" {
  config_path = "../../../..//vpc/network"
}

locals {
  #
  # Common configurables (may reference local.defaults)
  #
  variables = {
    label = {
      name = "admin-lb"
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
  source = "../../../../../..//modules/ec2/security_groups"
}
