#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  security_group_ids = [
    dependency.this_sg.outputs.security_group.id
  ]

  subnet_ids = dependency.this_vpc.outputs.subnet_ids
  vpc_id = dependency.this_vpc.outputs.vpc.id

  lb_internal     = false
  lb_type         = "application"

  lb_healthcheck  = {
    protocol = "HTTP"
    path     = "/"
    port     = "80"
  }

  lb_listeners = {
    web = [
      {
        port = "80"
        protocol = "HTTP"
      },
    ]
  }

  lb_targets = {
    web = [
      {
        port = "80",
        protocol = "HTTP",
        type = "ip",
      },
    ]
  }
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_sg" {
  config_path = "../../..//ec2/security_groups/admin/lb"
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
  source = "../../../../..//modules/ec2/load_balancers"
}
