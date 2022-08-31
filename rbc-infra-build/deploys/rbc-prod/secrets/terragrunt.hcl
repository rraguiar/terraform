#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  secrets_key_arn = dependency.this_kms.outputs.secrets_key.arn

  secrets = {
    "/rbc/prod/redis_host" = dependency.this_elasticache_podium.outputs.redis.endpoint,
    "/rbc/prod/node_keypair" = "UNDEFINED",
    "/rbc/prod/deploy_keypair" = "UNDEFINED",
    "/rbc/prod/db_password" = "UNDEFINED",
    "/rbc/prod/db_admin_password" = "UNDEFINED",
    "/rbc/prod/app_key" = "UNDEFINED",
    "/rbc/prod/db_mysql_zippo_password" = "UNDEFINED",
    "/rbc/prod/db_mysql_zippo_username" = "UNDEFINED",
    "/rbc/prod/db_mysql_zippo_host" = "UNDEFINED",
    "/rbc/prod/JWT_SECRET" = "UNDEFINED",
    "/rbc/prod/access_key_id" = "UNDEFINED",
    "/rbc/prod/ALGOLIA_SECRET" = "UNDEFINED",
    "/rbc/prod/ALGOLIA_APP_ID" = "UNDEFINED",
    "/rbc/prod/AWS_ACCESS_KEY_ID" = "UNDEFINED",
    "/rbc/prod/AWS_SECRET_ACCESS_KEY" = "UNDEFINED",
    "/rbc/prod/SSO_METADATA_ACCESS_PASSWORD" = "UNDEFINED",
    "/rbc/prod/MAIL_PASSWORD" = "UNDEFINED",
    "/rbc/prod/MAIL_USERNAME" = "UNDEFINED",
    "/rbc/prod/extended/db_username" = "UNDEFINED",
    "/rbc/prod/extended/redis_host" = dependency.this_elasticache_podium_extended.outputs.redis.endpoint,
    "/rbc/prod/extended/db_password" = "UNDEFINED",
    "/rbc/prod/extended/db_host" = dependency.this_rds_podium_extended.outputs.aurora.endpoint,
    "/rbc/prod/extended/db_database" = "UNDEFINED",
    "/rbc/prod/extended/db_admin_password" = "UNDEFINED",
    "/rbc/prod/extended/app_key" = "UNDEFINED",
    "/rbc/prod/extended/db_mysql_zippo_password" = "UNDEFINED",
    "/rbc/prod/EASYPOST_API_KEY" = "UNDEFINED",
  }
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_kms" {
  config_path = "..//kms"
}

dependency "this_rds_podium" {
  config_path = "..//rds/podium"
}

dependency "this_rds_podium_extended" {
  config_path = "..//rds//podium_extended"
}

dependency "this_elasticache_podium" {
  config_path = "..//elasticache/podium"
}

dependency "this_elasticache_podium_extended" {
  config_path = "..//elasticache/podium_extended"
}

locals {
  #
  # Common configurables (may reference local.defaults)
  #
  variables = {
    label = {
      name = "secrets"
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
  source = "../../..//modules/secrets"
}
