data "aws_caller_identity" "this" {}

module "label" {
  source = "../../resources/aws_data/label"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  label_order = ["namespace", "environment", "name"]
}

locals {
  aws_account_id = data.aws_caller_identity.this.account_id
}

#
# Secrets Encryption (eg. SSM)
#
module "secrets_key" {
  source = "../../resources/aws_kms/key"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "secrets"
  tags        = var.label.tags

  description = format("%s: secrets management key", module.label.id)
  policy      = module.secrets_policy.json
  label_order = ["namespace", "environment", "name"]
}

module "secrets_policy" {
  source = "../../resources/aws_kms/policy"

  account_id        = local.aws_account_id
  policy_principals = var.secrets_principals
}

#
# Storage Encryption (eg. S3, databases)
#
module "storage_key" {
  source = "../../resources/aws_kms/key"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "storage"
  tags        = var.label.tags

  description = format("%s: storage management key", module.label.id)
  policy      = module.storage_policy.json
  label_order = ["namespace", "environment", "name"]
}

module "storage_policy" {
  source = "../../resources/aws_kms/policy"

  account_id        = local.aws_account_id
  policy_principals = var.storage_principals
}
