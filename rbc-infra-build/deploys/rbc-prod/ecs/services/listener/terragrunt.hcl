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

  ecs_autoscaling_enabled = true
  ecs_capacity_provider_name = dependency.this_cluster.outputs.capacity_providers.private.ecs_node.name
  ecs_capacity_provider_weight = 1
  ecs_capacity_provider_base = 1

  lb_target_group_arn = dependency.this_lb.outputs.lb_targets["web"].arn
  lb_health_check_grace_period_seconds = 10

  route53_create_alias = true
  route53_zone_id = "Z1TWO1QSRGJC91"
  route53_fqdn = "rbc-listener.podiumrewards.com"
  route53_alias_fqdn = dependency.this_lb.outputs.lb.fqdn
  route53_alias_zone_id = dependency.this_lb.outputs.lb.zone_id

  security_group_ids = [
    dependency.this_sg.outputs.security_group.id
  ]

  storage_key_arn = dependency.this_kms.outputs.storage_key.arn
  secrets_key_arn = dependency.this_kms.outputs.secrets_key.arn


  s3_bucket_arns = [
    dependency.this_s3.outputs.buckets.main.arn
  ]

  subnet_ids = dependency.this_vpc.outputs.subnet_ids
  vpc_id = dependency.this_vpc.outputs.vpc.id

  # --------------------------------------------------------------------------------------------------------------------

  container_image = "738001968068.dkr.ecr.ca-central-1.amazonaws.com/saas_podium:api-v3.240.27"
  container_command = ["-c","/etc/supervisor/conf.d/listener.conf"]
  container_working_directory = "/var/www/html"
  container_port_mappings = [
    {
      protocol      = "tcp"
      containerPort = "80"
      hostPort      = "0"
    },
  ]

  ecs_cpu_units   = "1024"
  ecs_memory_mib  = "4096"

  ecs_desired_replicas    = "1"
  ecs_max_replicas        = "10"
  ecs_min_replicas        = "1"

  ecs_autoscaling_target_cpu_pct = "50"
  ecs_autoscaling_target_mem_pct = "50"
  ecs_autoscaling_scale_in_cooldown = "300"
  ecs_autoscaling_scale_out_cooldown = "300"

  ecs_assign_public_ip = false
  ecs_launch_type      = "EC2"
  ecs_network_mode     = "bridge"

  container_environment = [
    {
      name = "ADMIN_URL",
      value = "https://rbc-admin.podiumrewards.com"
    },
    {
      name = "APP_DEBUG",
      value = "true"
    },
    {
      name = "APP_DEPLOYMENT",
      value = "saas"
    },
    {
      name = "APP_ENV",
      value = "production"
    },
    {
      name = "APP_REQUEST_LOGS",
      value = "false"
    },
    {
      name = "APP_SERVICE",
      value = "listener"
    },
    {
      name = "APP_SSO_URL",
      value = "https://rbc-api.podiumrewards.com"
    },
    {
      name = "APP_URL",
      value = "https://rbc-api.podiumrewards.com"
    },
    {
      name = "AWS_BUCKET",
      value = "prod-infra-rbc-bucket"
    },
    {
      name = "AWS_REGION",
      value = "ca-central-1"
    },
    {
      name = "CACHE_DRIVER",
      value = "redis"
    },
    {
      name = "COMPANY_NAME",
      value = "Engage People Inc."
    },
    {
      name = "DB_MYSQL_ZIPPO_DATABASE",
      value = "rbc"
    },
    {
      name = "ENGAGE_PAYMENTS_CLIENT_SERVER_URL",
      value = ""
    },
    {
      name = "ENGAGE_PAYMENTS_HOST",
      value = ""
    },
    {
      name = "EXTENDED_ENV_HOST",
      value = ""
    },
    {
      name = "FILESYSTEM_DEFAULT_DRIVER",
      value = "s3"
    },
    {
      name = "FILESYSTEM_DRIVER",
      value = "s3"
    },
    {
      name = "KOUNT_WEBSITE",
      value = "DEFAULT"
    },
    {
      name = "LRG_ENV",
      value = ""
    },
    {
      name = "MAIL_DRIVER",
      value = "smtp"
    },
    {
      name = "MAIL_ENCRYPTION",
      value = "tls"
    },
    {
      name = "MAIL_FROM_ADDRESS",
      value = "noreply@podiumrewards.com"
    },
    {
      name = "MAIL_HOST",
      value = ""
    },
    {
      name = "MAIL_PORT",
      value = "2525"
    },
    {
      name = "PASSPORT_REFRESH_TTL",
      value = "36135"
    },
    {
      name = "PASSPORT_TOKEN_TTL",
      value = "36135"
    },
    {
      name = "QUEUE_DRIVER",
      value = "redis"
    },
    {
      name = "REDIS_DB",
      value = "1"
    },
    {
      name = "REDIS_PORT",
      value = "6379"
    },
    {
      name = "SCOUT_DRIVER",
      value = "algolia"
    },
    {
      name = "SCOUT_QUEUE",
      value = "true"
    },
    {
      name = "SENTRY_LARAVEL_DSN",
      value = ""
    },
    {
      name = "SESSION_DRIVER",
      value = "redis"
    },
    {
      name = "SSO_CERT_NAME_PRIVATE",
      value = "rbc-prod-saml.pem"
    },
    {
      name = "SSO_CERT_NAME_PUBLIC",
      value = "rbc-prod-saml.crt"
    },
    {
      name = "SSO_CERT_PATH",
      value = "/var/www/html/storage/certs/"
    },
    {
      name = "SSO_DEBUG_BACKTRACES",
      value = "true"
    },
    {
      name = "SSO_DEBUG_LOG_LEVEL",
      value = "true"
    },
    {
      name = "SSO_DEBUG_SAML",
      value = "true"
    },
    {
      name = "SSO_DEBUG_VALIDATEXML",
      value = "true"
    },
    {
      name = "SSO_IDP_TEST_MEMBERSITE_HOST",
      value = ""
    },
    {
      name = "SSO_IDP_TEST_URL",
      value = ""
    },
  ]

  container_secrets = [
    {
      name = "ALGOLIA_APP_ID",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/ALGOLIA_APP_ID"]
    },
    {
      name = "ALGOLIA_SECRET",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/ALGOLIA_SECRET"]
    },
    {
      name = "APP_KEY",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/app_key"]
    },
    {
      name = "AWS_ACCESS_KEY_ID",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/AWS_ACCESS_KEY_ID"]
    },
    {
      name = "AWS_SECRET_ACCESS_KEY",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/AWS_SECRET_ACCESS_KEY"]
    },
    {
      name = "DB_MYSQL_ZIPPO_HOST",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/db_mysql_zippo_host"]
    },
    {
      name = "DB_MYSQL_ZIPPO_PASSWORD",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/db_mysql_zippo_password"]
    },
    {
      name = "DB_MYSQL_ZIPPO_USERNAME",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/db_mysql_zippo_username"]
    },
    {
      name = "EASYPOST_API_KEY",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/EASYPOST_API_KEY"]
    },
    {
      name = "JWT_SECRET",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/JWT_SECRET"]
    },
    {
      name = "MAIL_PASSWORD",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/MAIL_PASSWORD"]
    },
    {
      name = "MAIL_USERNAME",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/MAIL_USERNAME"]
    },
    {
      name = "REDIS_HOST",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/redis_host"]
    },
    {
      name = "SSO_METADATA_ACCESS_PASSWORD",
      valueFrom = dependency.this_secrets.outputs.arns["rbc/prod/SSO_METADATA_ACCESS_PASSWORD"]
    },
  ]

  efs_volume_config = [
    {
      access_point_id = dependency.this_efs_ap.outputs.access_point.id
      file_system_id = dependency.this_efs_fs.outputs.file_system.id
      iam = "DISABLED"
      name = "shared_files"
      root_directory = "/"
      mount_point = "/var/www/html/shared_files"
      transit_encryption = "ENABLED"
      transit_encryption_port = null
      readonly = true
    }
  ]
}

#
# Terragrunt inter-stack dependencies
#
dependency "this_cluster" {
  config_path = "../../..//ecs/cluster"
}

dependency "this_efs_fs" {
  config_path = "../../..//efs/file_system/shared_files"
}

dependency "this_efs_ap" {
  config_path = "../../..//efs/access_point/shared_files"
}

dependency "this_kms" {
  config_path = "../../..//kms"
}

dependency "this_lb" {
  config_path = "../../..//ec2/load_balancers/listener"
}

dependency "this_s3" {
  config_path = "../../..//s3"
}

dependency "this_secrets" {
  config_path = "../../..//secrets"
}

dependency "this_sg" {
  config_path = "../../..//ec2/security_groups/listener/svc"
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
      name = "listener"
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
  source = "../../../../..//modules/ecs/services/ec2"
}
