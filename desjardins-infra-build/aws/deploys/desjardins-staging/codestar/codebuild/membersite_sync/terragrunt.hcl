#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws   = local.config.aws
  label = local.config.label

  source_location = dependency.this_codecommit.outputs.repo.clone_url_http
  source_type = "CODECOMMIT"

  secrets_key_arn = dependency.this_kms.outputs.secrets_key.arn

  security_group_ids = [
    dependency.this_sg.outputs.security_group.id
  ]

  # CodeBuild currently doesn't support VPC in ca-central-1d
  subnet_ids = dependency.this_vpc.outputs.subnet_ids_slice.private
  vpc_id = dependency.this_vpc.outputs.vpc.id

  env_vars = [
    {
      name = "AWS_ACCOUNT_ID"
      value = local.config.aws.account_id
      type = "PLAINTEXT"
    },
    {
      name = "AWS_DEFAULT_REGION"
      value = local.config.aws.region
      type = "PLAINTEXT"
    },
    {
      name = "ECR_ACCOUNT_ID"
      value = "AWS"
      type = "PLAINTEXT"
    },
    {
      name = "ECR_IMAGE_PREFIX"
      value = "desjardins-staging"
      type = "PLAINTEXT"
    },
    {
      name = "IMAGE_NAME"
      value = "membersite"
      type = "PLAINTEXT"
    },
    {
      name = "IMAGE_TAG"
      value = "desjardins-prod-v2.0.7.33-84"
      type = "PLAINTEXT"
    },
    {
      name = "QUAY_REPO_NAME"
      value = "quay.io/engage"
      type = "PLAINTEXT"
    },
    {
      name = "QUAY_ACCOUNT_ID"
      value = "engage+desjardins"
      type = "PLAINTEXT"
    },
    {
      name = "QUAY_TOKEN"
      value = dependency.this_ssm.outputs.names["desjardins/codebuild/quay_token"]
      type = "PARAMETER_STORE"
    }
  ]

}

#
# Terragrunt inter-stack dependencies
#
dependency "this_codecommit" {
  config_path = "../../codecommit/quayio_sync"
}

dependency "this_kms" {
  config_path = "../../../kms"
}

dependency "this_sg" {
  config_path = "../../../ec2/security_groups/codebuild"
}

dependency "this_ssm" {
  config_path = "../../../ssm/parameters"
}

dependency "this_vpc" {
  config_path = "../../../vpc/network"
}

locals {
  #
  # Common configurables (may reference local.defaults)
  #
  variables = {
    label = {
      name = "desjardins-membersite-sync"
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
  source = "../../../../..//modules/codestar/codebuild"
}
