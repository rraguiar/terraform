#
# Computed Secrets / DB Admin User
#
data "aws_secretsmanager_secret" "db_admin_password_secret" {
  name = var.db_admin_password_secret
}

data "aws_secretsmanager_secret_version" "db_admin_password_version" {
  secret_id = data.aws_secretsmanager_secret.db_admin_password_secret.id
}

data "aws_secretsmanager_secret" "db_name_secret" {
  name = var.db_name_secret
}

data "aws_secretsmanager_secret_version" "db_name_version" {
  secret_id = data.aws_secretsmanager_secret.db_name_secret.id
}

#
# RDS / Aurora
#
module "aurora_cluster" {
  source = "git::https://github.com/cloudposse/terraform-aws-rds-cluster.git?ref=0.45.0"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags
  label_order = ["stage", "namespace", "environment", "name"]

  engine         = var.engine
  engine_version = var.engine_version

  cluster_family = var.cluster_family
  cluster_size   = var.cluster_size
  instance_type  = var.instance_type

  admin_user     = var.db_admin_user
  admin_password = data.aws_secretsmanager_secret_version.db_admin_password_version.secret_string
  db_name        = data.aws_secretsmanager_secret_version.db_name_version.secret_string
  db_port        = var.db_port

  vpc_id              = var.vpc_id
  allowed_cidr_blocks = var.allowed_cidr_blocks
  security_groups     = var.security_group_ids
  subnets             = var.subnet_ids
  zone_id             = var.route53_zone_id

  storage_encrypted = var.storage_key_arn == null ? false : true
  kms_key_arn       = var.storage_key_arn
}
