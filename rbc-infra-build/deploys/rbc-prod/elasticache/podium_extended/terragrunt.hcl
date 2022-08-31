#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  storage_key_arn = dependency.this_kms.outputs.storage_key.arn

  engine = "redis"
  family = "redis5.0"
  engine_version = "5.0.6"
  instance_type = "cache.r5.large"
  cluster_size = 2

  availability_zones = [
    "ca-central-1a",
    "ca-central-1b",
    "ca-central-1d",
  ]

  security_group_rules = [
    {
      protocol    = "tcp"
      type        = "ingress"
      from_port   = "6379"
      to_port     = "6379"
      cidr_blocks = ["10.100.0.0/16"]
    }
  ]

  subnet_ids = dependency.this_vpc.outputs.subnet_ids["private"]

  vpc_id = dependency.this_vpc.outputs.vpc.id
}

#
# Terragrunt stack dependencies
#
dependency "this_kms" {
  config_path = "../..//kms"
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
      name = "podium-extended-redis"
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
  source = "../../../..//modules/elasticache/redis"
}
