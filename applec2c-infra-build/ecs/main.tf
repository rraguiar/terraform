# Fetch environment information and share with the components that will be deployed. 
# Collect the AWS Region name from providers.tf 
data "aws_region" "current" {}

# Collect the KMS (Key Encryption) information
data "aws_kms_alias" "ebs" {
  name = var.kms_key_id
}

# Collect the IAM Role name used by the Task
data "aws_iam_role" "executionrole" {
  name = "${var.environment}-${var.customer}-${var.application_name}-ecs-TaskExecutionRole"
}

# Collect the Target group arn
data "aws_lb_target_group" "alb" {
  name = "${var.environment}-${var.customer}-${var.application_name}-lb-tg"
}

# Collect secrets from AWS Secrets Manager - APP_KEY
data "aws_secretsmanager_secret" "app_key" {
  arn = "arn:aws:secretsmanager:${data.aws_region.current.name}:${var.account_id}:secret:${var.application_name}/${var.environment}/app_key"
}
data "aws_secretsmanager_secret_version" "app_key" {
  secret_id = data.aws_secretsmanager_secret.app_key.id
}

# Collect secrets from AWS Secrets Manager - DB_DATABASE
data "aws_secretsmanager_secret" "db_database" {
  arn = "arn:aws:secretsmanager:${data.aws_region.current.name}:${var.account_id}:secret:${var.application_name}/${var.environment}/db_database"
}
data "aws_secretsmanager_secret_version" "db_database" {
  secret_id = data.aws_secretsmanager_secret.db_database.id
}

# Collect secrets from AWS Secrets Manager - DB_HOST
data "aws_secretsmanager_secret" "db_host" {
  arn = "arn:aws:secretsmanager:${data.aws_region.current.name}:${var.account_id}:secret:${var.application_name}/${var.environment}/db_host"
}
data "aws_secretsmanager_secret_version" "db_host" {
  secret_id = data.aws_secretsmanager_secret.db_host.id
}

# Collect secrets from AWS Secrets Manager - DB_PASSWORD
data "aws_secretsmanager_secret" "db_password" {
  arn = "arn:aws:secretsmanager:${data.aws_region.current.name}:${var.account_id}:secret:${var.application_name}/${var.environment}/db_password"
}
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}

# Collect secrets from AWS Secrets Manager - DB_USERNAME
data "aws_secretsmanager_secret" "db_username" {
  arn = "arn:aws:secretsmanager:${data.aws_region.current.name}:${var.account_id}:secret:${var.application_name}/${var.environment}/db_username"
}
data "aws_secretsmanager_secret_version" "db_username" {
  secret_id = data.aws_secretsmanager_secret.db_username.id
}

/*
# Collect secrets from AWS Secrets Manager - REDIS_HOST
data "aws_secretsmanager_secret" "redis_host" {
  arn = "arn:aws:secretsmanager:${data.aws_region.current.name}:${var.account_id}:secret:${var.application_name}/${var.environment}/redis_host"
}
data "aws_secretsmanager_secret_version" "redis_host" {
  secret_id = data.aws_secretsmanager_secret.redis_host.id
}
*/