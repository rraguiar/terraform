locals {
  principals = {
    account = var.assuming_account_ids
  }
}

#
# Superuser
#
module "superuser_role" {
  source = "../../aws_iam/role_assumeable"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = "superuser"
  tags        = var.tags

  policy_arns = var.superuser_policy_arns
  policy_map  = var.superuser_policy_map
  principals  = local.principals

  max_session_duration = var.max_session_duration
}

#
# Developer
#
module "developer_role" {
  source = "../../aws_iam/role_assumeable"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = "developer"
  tags        = var.tags

  policy_arns = var.developer_policy_arns
  policy_map  = var.developer_policy_map
  principals  = local.principals

  max_session_duration = var.max_session_duration
}

#
# Read Only
#
module "readonly_role" {
  source = "../../aws_iam/role_assumeable"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = "readonly"
  tags        = var.tags

  policy_arns = var.readonly_policy_arns
  policy_map  = var.readonly_policy_map
  principals  = local.principals

  max_session_duration = var.max_session_duration
}

#
# Terraform
#
module "terraform_role" {
  source = "../../aws_iam/role_assumeable"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = "terraform"
  tags        = var.tags

  policy_arns = var.terraform_policy_arns
  policy_map  = var.terraform_policy_map
  principals  = local.principals

  max_session_duration = var.max_session_duration
}
