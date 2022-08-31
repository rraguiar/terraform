# AWS Secrets for Application Key ###################################################################
resource "aws_secretsmanager_secret" "application_key" {
  name                    = "${var.application_name}/${var.environment}/app_key"
  description             = "Application Key"
  recovery_window_in_days = 0
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.application_name}/${var.environment}/app_key"
      "service_role" = "secrets"
    })
  )
}

# Application Key secret value for test only. DO NOT ADD PRODUCTION VALUES HERE #####################
resource "aws_secretsmanager_secret_version" "application_key" {
  secret_id     = aws_secretsmanager_secret.application_key.id
  secret_string = "example-string-to-protect"
}

# AWS Secrets Policy for Application Key record #####################################################
# The policy is used to allow/deny resources from reading the secrets. 
resource "aws_secretsmanager_secret_policy" "application_key" {
  secret_arn = aws_secretsmanager_secret.application_key.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAllPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}

# AWS Secrets for DB Name ###########################################################################
resource "aws_secretsmanager_secret" "db_name" {
  name                    = "${var.application_name}/${var.environment}/db_database"
  description             = "Database Name"
  recovery_window_in_days = 0
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.application_name}/${var.environment}/db_database"
      "service_role" = "secrets"
    })
  )
}

# DB name secret value for test only. The standard is the db name and project name be the same ######
resource "aws_secretsmanager_secret_version" "db_name" {
  secret_id     = aws_secretsmanager_secret.db_name.id
  secret_string = var.project
}

# AWS Secrets Policy for DB Name record #############################################################
# The policy is used to allow/deny resources from reading the secrets. 
resource "aws_secretsmanager_secret_policy" "db_name" {
  secret_arn = aws_secretsmanager_secret.db_name.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAllPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}

# AWS Secrets for DB Host ###########################################################################
resource "aws_secretsmanager_secret" "db_host" {
  name                    = "${var.application_name}/${var.environment}/db_host"
  description             = "Database Host - Endpoint"
  recovery_window_in_days = 0
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.application_name}/${var.environment}/db_host"
      "service_role" = "secrets"
    })
  )
}

# DB host secret value for test only. This value should be changed after RDS DB deployed ############
resource "aws_secretsmanager_secret_version" "db_host" {
  secret_id     = aws_secretsmanager_secret.db_host.id
  secret_string = "example-string-to-protect"
}

# AWS Secrets Policy for DB Host record #############################################################
# The policy is used to allow/deny resources from reading the secrets. 
resource "aws_secretsmanager_secret_policy" "db_host" {
  secret_arn = aws_secretsmanager_secret.db_host.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAllPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}

# AWS Secrets for DB Admin User Password ############################################################
resource "aws_secretsmanager_secret" "db_admin_password" {
  name                    = "${var.application_name}/${var.environment}/db_admin_password"
  description             = "Database Admin password"
  recovery_window_in_days = 0
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.application_name}/${var.environment}/db_admin_password"
      "service_role" = "secrets"
    })
  )
}

# DB admin password secret value for test only. This value should be changed before RDS database ####
# deployment on AWS Console - DO NOT ADD PRODUCTION VALUES HERE #####################################
resource "aws_secretsmanager_secret_version" "db_admin_password" {
  secret_id     = aws_secretsmanager_secret.db_admin_password.id
  secret_string = "example-string-to-protect"
}

# AWS Secrets Policy for DB Admin User record #######################################################
# The policy is used to allow/deny resources from reading the secrets. 
resource "aws_secretsmanager_secret_policy" "db_admin_password" {
  secret_arn = aws_secretsmanager_secret.db_admin_password.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAllPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}

# AWS Secrets for DB Application User Password ######################################################
resource "aws_secretsmanager_secret" "db_user_password" {
  name                    = "${var.application_name}/${var.environment}/db_password"
  description             = "Application User - Database User password"
  recovery_window_in_days = 0
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.application_name}/${var.environment}/db_password"
      "service_role" = "secrets"
    })
  )
}

# DB user password secret value for test only. This value should be changed before RDS database #####
# deployment on AWS Console - DO NOT ADD PRODUCTION VALUES HERE #####################################
resource "aws_secretsmanager_secret_version" "db_user_password" {
  secret_id     = aws_secretsmanager_secret.db_user_password.id
  secret_string = "example-string-to-protect"
}

# AWS Secrets Policy for DB Application User record #################################################
# The policy is used to allow/deny resources from reading the secrets. 
resource "aws_secretsmanager_secret_policy" "db_user_password" {
  secret_arn = aws_secretsmanager_secret.db_user_password.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAllPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}

# AWS Secrets for DB Username Password ##############################################################
resource "aws_secretsmanager_secret" "db_username" {
  name                    = "${var.application_name}/${var.environment}/db_username"
  description             = "Database Username"
  recovery_window_in_days = 0
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.application_name}/${var.environment}/db_username"
      "service_role" = "secrets"
    })
  )
}

# DB username secret value for test only. The standard is the db name and project name be the same ##
resource "aws_secretsmanager_secret_version" "db_username" {
  secret_id     = aws_secretsmanager_secret.db_username.id
  secret_string = var.project
}

# AWS Secrets Policy for DB Username record #########################################################
# The policy is used to allow/deny resources from reading the secrets. 
resource "aws_secretsmanager_secret_policy" "db_username" {
  secret_arn = aws_secretsmanager_secret.db_username.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAllPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}

# AWS Secrets for Redis Host ########################################################################
#resource "aws_secretsmanager_secret" "redis_host" {
#  name                    = "${var.application_name}/${var.environment}/redis_host"
#  description             = "Redis Host - Endpoint"
#  recovery_window_in_days = 0
#  lifecycle {
#    create_before_destroy = true
#  }
#  tags = merge(
#    local.common_tags,
#    map(
#      "Name", "${var.application_name}/${var.environment}/redis_host",
#      "service_role", "secrets"
#    )
#  )
#}

# Redis host secret value for test only. This value should be changed after RDS DB deployment #######
#resource "aws_secretsmanager_secret_version" "redis_host" {
#  secret_id     = aws_secretsmanager_secret.redis_host.id
#  secret_string = "example-string-to-protect"
#}

# AWS Secrets Policy for Redis Host record ##########################################################
# The policy is used to allow/deny resources from reading the secrets. 
#resource "aws_secretsmanager_secret_policy" "redis_host" {
#  secret_arn = aws_secretsmanager_secret.redis_host.arn
#
#  policy = <<POLICY
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "EnableAllPermissions",
#      "Effect": "Allow",
#      "Principal": {
#        "AWS": "*"
#      },
#      "Action": "secretsmanager:GetSecretValue",
#      "Resource": "*"
#    }
#  ]
#}
#POLICY
#}

# AWS Secrets for EC2 Deploy Server keypair #########################################################
resource "aws_secretsmanager_secret" "deploy_keypair" {
  name                    = "${var.application_name}/${var.environment}/deploy_keypair"
  description             = "EC2 Deploy Server Keypair"
  recovery_window_in_days = 0
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.application_name}/${var.environment}/deploy_keypair"
      "service_role" = "secrets"
    })
  )
}

# Deploy server keypair secret value for test only. This value should be changed before deployment ##
# deployment on AWS Console - DO NOT ADD PRODUCTION VALUES HERE #####################################
resource "aws_secretsmanager_secret_version" "deploy_keypair" {
  secret_id     = aws_secretsmanager_secret.deploy_keypair.id
  secret_string = "example-string-to-protect"
}

# AWS Secrets Policy for EC2 Deploy Server Keypair record ###########################################
# The policy is used to allow/deny resources from reading the secrets. 
resource "aws_secretsmanager_secret_policy" "deploy_keypair" {
  secret_arn = aws_secretsmanager_secret.deploy_keypair.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAllPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}

# AWS Secrets for EC2 Node Server keypair ###########################################################
resource "aws_secretsmanager_secret" "node_keypair" {
  name                    = "${var.application_name}/${var.environment}/node_keypair"
  description             = "EC2 Node Server Keypair"
  recovery_window_in_days = 0
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.application_name}/${var.environment}/node_keypair"
      "service_role" = "secrets"
    })
  )
}

# Deploy server keypair secret value for test only. This value should be changed before deployment ##
# deployment on AWS Console - DO NOT ADD PRODUCTION VALUES HERE #####################################
resource "aws_secretsmanager_secret_version" "node_keypair" {
  secret_id     = aws_secretsmanager_secret.node_keypair.id
  secret_string = "example-string-to-protect"
}

# AWS Secrets Policy for EC2 Node Server Keypair record #############################################
# The policy is used to allow/deny resources from reading the secrets. 
resource "aws_secretsmanager_secret_policy" "node_keypair" {
  secret_arn = aws_secretsmanager_secret.node_keypair.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAllPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}