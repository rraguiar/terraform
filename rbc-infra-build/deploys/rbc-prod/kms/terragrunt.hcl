#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  storage_principals = {
    encrypt = {
      account_ids = [
        "738001968068"  # rawinc
      ],
    }
    decrypt = {
      account_ids = [
        "738001968068"  # rawinc
      ],
      aws = [
        dependency.this_roles.outputs.iam_role_arns.superuser,
        dependency.this_roles.outputs.iam_role_arns.developer,
      ]
    }
  }

  secrets_principals = {
    encrypt = {
      account_ids = [
        "738001968068"  # rawinc
      ]
    }
    decrypt = {
      account_ids = [
        "738001968068"  # rawinc
      ],
      aws = [
        dependency.this_roles.outputs.iam_role_arns.superuser,
        dependency.this_roles.outputs.iam_role_arns.developer,
      ]
    }
  }
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_roles" {
  config_path = "..//iam/roles"
}

locals {
  #
  # Common configurables (may reference local.defaults)
  #
  variables = {
    label = {
      name = "kms"
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
  source = "../../..//modules/kms"
}
