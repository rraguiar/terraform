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

  # *.podiumrewards.com
  certificate_arn = "arn:aws:acm:ca-central-1:738001968068:certificate/ea9dd45c-1399-459b-9634-52bff2c8be8d"

  lb_internal     = false
  lb_type         = "application"

  lb_healthcheck  = {
    protocol = "HTTP"
    path     = "/"
  }

  lb_listeners = {
    web = [
      {
        port = "80"
        protocol = "HTTP"
      },
      {
        port = "443"
        protocol = "HTTPS"
      },
    ]
  }

  lb_targets = {
    web = [
      {
        port = "80",
        protocol = "HTTP",
        type = "instance",
      },
    ]
  }
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_sg" {
  config_path = "../../..//ec2/security_groups/extended_nginx/lb"
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
      name = "extd-nginx-lb"
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
  source = "../../../../..//modules/ec2/load_balancers"
}
