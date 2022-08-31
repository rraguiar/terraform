#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  db_name = "desjardins_uat"
  db_user_ssm = dependency.this_ssm.outputs.names["desjardins/db/username"]
  db_passwd_ssm = dependency.this_ssm.outputs.names["desjardins/db/password"]
  db_parameter_group = "mysql5.7"
  engine = "mysql"
  engine_version = "5.7.26"
  instance_class = "db.m5.large"

  apply_immediately = true

  security_group_ids = [
    dependency.this_sg_api.outputs.security_group.id,
  ]

  snapshot_identifier = "desjardins-uat-202105181720"

  storage_key_arn = dependency.this_kms.outputs.storage_key.arn

  subnet_ids = dependency.this_vpc.outputs.subnet_ids.private
  vpc_id = dependency.this_vpc.outputs.vpc.id
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_kms" {
  config_path = "../..//kms"
}

dependency "this_sg_api" {
  config_path = "../..//ec2/security_groups/api/svc"
}

dependency "this_ssm" {
  config_path = "../..//ssm/parameters"
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
      name = "mysql"
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
  source = "../../../..//modules/rds/mysql"
}
