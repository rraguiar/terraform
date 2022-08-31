#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  secrets_key_arn = dependency.this_kms.outputs.secrets_key.arn

  parameters = {
    "desjardins/codebuild/quay_token" = {
      type  = "SecureString"
    },
    # keys from fdebenardis // 20210504
    "desjardins/app_key" = {
      type  = "SecureString"
    },
    "desjardins/publish_key" = {
      type  = "SecureString"
    },
    "desjardins/app/account/products/card_number_key" = {
      type  = "SecureString"
    },
    "desjardins/app/account/products/account_number_key" = {
      type  = "SecureString"
    },
    "desjardins/app/transaction_records/account/product_number_key" = {
      type  = "SecureString"
    },
    "desjardins/db/username" = {
      type  = "SecureString"
    },
    "desjardins/db/password" = {
      type  = "SecureString"
    },
    "desjardins/db/statements/username" = {
      type  = "SecureString"
    },
    "desjardins/db/statements/password" = {
      type  = "SecureString"
    },
    "desjardins/mail/username" = {
      type  = "SecureString"
    },
    "desjardins/mail/password" = {
      type  = "SecureString"
    },
    "desjardins/asset/api_key" = {
      type  = "SecureString"
    },
    "desjardins/tax/api_key" = {
      type  = "SecureString"
    },
    "desjardins/easy_post/api_key" = {
      type  = "SecureString"
    },
    "desjardins/merchant_id" = {
      type  = "SecureString"
    },
    "desjardins/api_access_passcode" = {
      type  = "SecureString"
    },
    "desjardins/sftp/myaxs/login" = {
      type  = "SecureString"
    },
    "desjardins/sftp/myaxs/pass" = {
      type  = "SecureString"
    },
    "desjardins/sftp/hinge/login" = {
      type  = "SecureString"
    },
    "desjardins/sftp/hinge/pass" = {
      type  = "SecureString"
    },
    "desjardins/sftp/login" = {
      type  = "SecureString"
    },
    "desjardins/sftp/pass" = {
      type  = "SecureString"
    },
    "desjardins/desjardin/login" = {
      type  = "SecureString"
    },
    "desjardins/gpg/user_id" = {
      type  = "SecureString"
    },
    "desjardins/sftp/netsuite/login" = {
      type  = "SecureString"
    },
    "desjardins/sftp/netsuite/pass" = {
      type  = "SecureString"
    },
  }
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_kms" {
  config_path = "../../kms"
}

locals {
  #
  # Common configurables (may reference local.defaults)
  #
  variables = {
    label = {
      name = "ssm"
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
  source = "../../../..//modules/ssm/parameters"
}
