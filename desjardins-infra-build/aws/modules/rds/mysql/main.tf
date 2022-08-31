#
# Computed SSM Parameters
#
data "aws_ssm_parameter" "db_user" {
  name            = var.db_user_ssm
  with_decryption = true
}

data "aws_ssm_parameter" "db_passwd" {
  name            = var.db_passwd_ssm
  with_decryption = true
}

#
# MySQL instance
#
module "mysql" {
  source = "git@github.com:cloudposse/terraform-aws-rds.git?ref=0.35.1"

  namespace   = var.label.namespace
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags
  label_order = ["namespace", "environment", "name"]

  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately           = var.apply_immediately

  database_name = var.db_name
  //  database_user     = data.aws_ssm_parameter.db_user.value
  //  database_password = data.aws_ssm_parameter.db_passwd.value
  database_port = var.db_port
  host_name     = var.db_host_name

  allocated_storage               = var.allocated_storage
  backup_retention_period         = var.backup_retention_period
  ca_cert_identifier              = var.ca_cert_identitier
  db_parameter_group              = var.db_parameter_group
  dns_zone_id                     = var.dns_zone_id
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  kms_key_arn                     = var.storage_key_arn
  multi_az                        = var.multi_az
  publicly_accessible             = var.publicly_accessible
  security_group_ids              = var.security_group_ids
  snapshot_identifier             = var.snapshot_identifier
  storage_encrypted               = var.storage_key_arn == null ? false : true
  storage_type                    = var.storage_type
  subnet_ids                      = var.subnet_ids
  vpc_id                          = var.vpc_id
}
