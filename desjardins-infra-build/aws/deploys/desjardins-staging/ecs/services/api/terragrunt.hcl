#
# Terraform module input variables
# - may reference values from local.config
# - may reference values from dependency.XXX.outputs
#
inputs = {
  aws = local.config.aws
  label = local.config.label

  ecs_cluster_id = dependency.this_cluster.outputs.ecs_cluster.id
  ecs_cluster_name = dependency.this_cluster.outputs.ecs_cluster.name
  ecs_exec_role_arn = dependency.this_cluster.outputs.ecs_exec_role.arn

  lb_target_group_arn = dependency.this_lb.outputs.lb_targets["web"].arn
  lb_health_check_grace_period_seconds = 10

  security_group_ids = [
    dependency.this_sg.outputs.security_group.id
  ]

  storage_key_arn = dependency.this_kms.outputs.storage_key.arn

  subnet_ids = dependency.this_vpc.outputs.subnet_ids
  vpc_id = dependency.this_vpc.outputs.vpc.id

  container_image = "738001968068.dkr.ecr.ca-central-1.amazonaws.com/desjardins-staging-api:desjardins-prod-v2.1.0.17-77"
  container_command = [ ]
  container_port_mappings = [
    {
      protocol      = "tcp"
      containerPort = "80"
      hostPort      = "80"
    },
  ]

  ecs_cpu_units   = "512"
  ecs_memory_mib  = "1024"

  ecs_desired_replicas    = "1"
  ecs_max_replicas        = "1"
  ecs_min_replicas        = "1"

  ecs_autoscaling_target_cpu_pct = "50"
  ecs_autoscaling_target_mem_pct = "50"
  ecs_autoscaling_scale_in_cooldown = "300"
  ecs_autoscaling_scale_out_cooldown = "300"

  ecs_assign_public_ip = true
  ecs_launch_type      = "FARGATE"
  ecs_network_mode     = "awsvpc"
  ecs_platform_version = "1.4.0"

  linux_parameters = {
    capabilities = null
    devices = null
    initProcessEnabled = true
    maxSwap = null
    sharedMemorySize = null
    swappiness = null
    tmpfs = null
  }

  container_environment = [
    {
      name = "API_URL"
      value = "desjardins-uat-api.podiumrewards.com"
    },
    {
      name = "APP_ENV"
      value = "uat"
    },
    {
      name = "APP_DEPLOYMENT"
      value = "desjardins"
    },
    {
      name = "APP_LOGS"
      value = "Daily"
    },
    {
      name = "APP_REQUEST_LOGS"
      value = "false"
    },
    {
      name = "APP_DEBUG"
      value = "true"
    },
    {
      name = "APP_PARTNER_NAME"
      value = "Desjardins"
    },
    {
      name = "APP_PROGRAM_NAME"
      value = "BONUSDOLLARS"
    },
    {
      name = "USE_LRG"
      value = "false"
    },
    {
      name = "TEST_MEMBERSITE_URL"
      value = "http://desjardins-uat.podiumrewards.com"
    },
    {
      name = "MAX_LOGIN_ATTEMPTS"
      value = "6"
    },
    {
      name = "LOCKOUT_TIME_MINUTES"
      value = "60"
    },
    {
      name = "COMPANY_NAME"
      value = "Engage People Inc."
    },
    {
      name = "DB_HOST"
      value = dependency.this_rds.outputs.mysql.instance_address
    },
    {
      name = "DB_DATABASE"
      value = "desjardins_uat"
    },
    {
      name = "DB_STATEMENTS_HOST"
      value = dependency.this_rds.outputs.mysql.instance_address
    },
    {
      name = "DB_STATEMENTS_PORT"
      value = "3306"
    },
    {
      name = "DB_STATEMENTS_DATABASE"
      value = "desjardins_uat"
    },
    {
      name = "CACHE_DRIVER"
      value = "file"
    },
    {
      name = "SESSION_DRIVER"
      value = "file"
    },
    {
      name = "QUEUE_DRIVER"
      value = "sync"
    },
    {
      name = "MAIL_DRIVER"
      value = "smtp"
    },
    {
      name = "MAIL_HOST"
      value = "smtp.mailtrap.io"
    },
    {
      name = "MAIL_PORT"
      value = "2525"
    },
    {
      name = "MAIL_ENCRYPTION"
      value = ""
    },
    {
      name = "MAIL_FROM"
      value = "noreply@podiumrewards.com"
    },
    {
      name = "ASSET_API"
      value = "https://desjardins-uat-assets.podiumrewards.com"
    },
    {
      name = "ASSET_URL"
      value = "https://desjardins-uat-assets.podiumrewards.com"
    },
    {
      name = "AWS_BUCKET"
      value = "assettest.podiumrewards.com"
    },
    {
      name = "AWS_BUCKET_URL"
      value = "http://assettest.podiumrewards.com"
    },
    {
      name = "AWS_TRANSCODER_PIPELINE_ID"
      value = ""
    },
    {
      name = "AWS_TRANSCODER_PRESET_ID"
      value = ""
    },
    {
      name = "AWS_TRANSCODER_EXTENSION"
      value = ""
    },
    {
      name = "ACTIVE_ACCEPTANCE_TEST"
      value = "false"
    },
    {
      name = "SKIP_SLACK_INFO"
      value = "true"
    },
    {
      name = "SLACK_CHANNEL"
      value = "#podiumdeployprocess"
    },
    {
      name = "USERS_FILES_DIRECTORY"
      value = "/usr/share/nginx/html/web/import_files"
    },
    {
      name = "BALANCE_FILES_DIRECTORY"
      value = "/usr/share/nginx/html/web/import_files"
    },
    {
      name = "BRAND_FILES_DIRECTORY"
      value = "/usr/share/nginx/html/web/import_files"
    },
    {
      name = "CATEGORY_FILES_DIRECTORY"
      value = "/usr/share/nginx/html/web/import_files"
    },
    {
      name = "PRODUCT_FILES_DIRECTORY"
      value = "/usr/share/nginx/html/web/import_files"
    },
    {
      name = "HOLIDAY_FILES_DIRECTORY"
      value = "/usr/share/nginx/html/web/import_files"
    },
    {
      name = "STATEMENTS_FILES_DIRECTORY"
      value = "/usr/share/nginx/html/web/import_files"
    },
    {
      name = "ORDERS_UPLOAD_DIRECTORY"
      value = "/usr/share/nginx/html/web/import_files"
    },
    {
      name = "SFTP_MYAXS_HOST"
      value = "52.14.251.236"
    },
    {
      name = "SFTP_HINGE_HOST"
      value = "52.14.251.236"
    },
    {
      name = "SFTP_HOST"
      value = "52.14.251.236"
    },
    {
      name = "SFTP_LOCAL_FOLDER"
      value = "/usr/share/nginx/html/web/storage/files/"
    },
    {
      name = "RIDEAU_FILES_DIRECTORY"
      value = "/sftp/rideausftp/incoming/pending/"
    },
    {
      name = "DESJARDIN_HOST"
      value = "b2b.scd-desjardins.com"
    },
    {
      name = "DESJARDIN_SSH"
      value = "/root/.ssh/id_rsa"
    },
    {
      name = "APP_INCLUSIVE_PRICING"
      value = "true"
    },
    {
      name = "SFTP_NETSUITE_HOST"
      value = "sftp.engagepeople.com"
    },
    {
      name = "SFTP_NETSUITE_FOLDER"
      value = "/Netsuite/sandbox/customers/desj_bonusdollars/"
    },
  ]

  container_secrets = [
    {
      name = "APP_KEY"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/app_key"]
    },
    {
      name = "PUBLISH_KEY"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/publish_key"]
    },
    {
      name = "APP_ACCOUNT_PRODUCTS_CARD_NUMBER_KEY"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/app/account/products/card_number_key"]
    },
    {
      name = "APP_ACCOUNT_PRODUCTS_ACCOUNT_NUMBER_KEY"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/app/account/products/account_number_key"]
    },
    {
      name = "APP_TRANSACTION_RECORDS_ACCOUNT_PRODUCT_NUMBER_KEY"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/app/transaction_records/account/product_number_key"]
    },
    {
      name = "DB_USERNAME"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/db/username"]
    },
    {
      name = "DB_PASSWORD"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/db/password"]
    },
    {
      name = "DB_STATEMENTS_USERNAME"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/db/statements/username"]
    },
    {
      name = "DB_STATEMENTS_PASSWORD"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/db/statements/password"]
    },
    {
      name = "MAIL_USERNAME"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/db/statements/password"]
    },
    {
      name = "MAIL_PASSWORD"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/db/statements/password"]
    },
    {
      name = "ASSET_API_KEY"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/asset/api_key"]
    },
    {
      name = "TAX_API_KEY"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/tax/api_key"]
    },
    {
      name = "EASY_POST_API_KEY"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/easy_post/api_key"]
    },
    {
      name = "MERCHANT_ID"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/merchant_id"]
    },
    {
      name = "API_ACCESS_PASSCODE"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/api_access_passcode"]
    },
    {
      name = "SFTP_MYAXS_LOGIN"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/sftp/myaxs/login"]
    },
    {
      name = "SFTP_MYAXS_PASS"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/sftp/myaxs/pass"]
    },
    {
      name = "SFTP_HINGE_LOGIN"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/sftp/hinge/login"]
    },
    {
      name = "SFTP_HINGE_PASS"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/sftp/hinge/pass"]
    },
    {
      name = "SFTP_LOGIN"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/sftp/login"]
    },
    {
      name = "SFTP_PASS"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/sftp/pass"]
    },
    {
      name = "DESJARDIN_LOGIN"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/sftp/pass"]
    },
    {
      name = "GPG_USER_ID"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/gpg/user_id"]
    },
    {
      name = "SFTP_NETSUITE_LOGIN"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/sftp/netsuite/login"]
    },
    {
      name = "SFTP_NETSUITE_PASS"
      valueFrom = dependency.this_ssm_parameters.outputs.arns["desjardins/sftp/netsuite/pass"]
    },
  ]

  efs_volumes = [
    {
      name = "netsuite",
      container_path = "/Netsuite",
      volume_config = {
        file_system_id = dependency.this_efs_netsuite.outputs.file_system.id
        root_directory = "/"
      }
    },
    {
      name = "sftp",
      container_path = "/sftp",
      volume_config = {
        file_system_id = dependency.this_efs_sftp.outputs.file_system.id
        root_directory = "/"
      }
    },
    {
      name = "web-import-files",
      container_path = "/usr/share/nginx/html/web/import_files",
      volume_config = {
        file_system_id = dependency.this_efs_web_import_files.outputs.file_system.id
        root_directory = "/"
      }
    },
    {
      name = "web-storage",
      container_path = "/usr/share/nginx/html/web/storage",
      volume_config = {
        file_system_id = dependency.this_efs_web_storage.outputs.file_system.id
        root_directory = "/"
      }
    }
  ]
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_cluster" {
  config_path = "../../..//ecs/cluster"
}

dependency "this_efs_netsuite" {
  config_path = "../../..//efs/netsuite"
}

dependency "this_efs_sftp" {
  config_path = "../../..//efs/sftp"
}

dependency "this_efs_web_import_files" {
  config_path = "../../..//efs/web_import_files"
}

dependency "this_efs_web_storage" {
  config_path = "../../..//efs/web_storage"
}

dependency "this_kms" {
  config_path = "../../..//kms"
}

dependency "this_lb" {
  config_path = "../../..//ec2/load_balancers/api"
}

dependency "this_rds" {
  config_path = "../../..//rds/mysql"
}

dependency "this_sg" {
  config_path = "../../..//ec2/security_groups/api/svc"
}

dependency "this_ssm_parameters" {
  config_path = "../../..//ssm/parameters"
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
      name = "api"
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
  source = "../../../../..//modules/ecs/services/fargate"
}
