locals {
  org_account_access_role_name = "OrganizationAccountAccessRole"

  org_account_access_role_arn = format(
    "arn:aws:iam::%s:role/%s",
    var.aws.account_id,
    local.org_account_access_role_name,
  )

  arns = merge(
    { org : local.org_account_access_role_arn },
    module.account_roles.arns
  )

  names = merge(
    { org : local.org_account_access_role_name },
    module.account_roles.names
  )
}

#
# IAM roles on all accounts
#
module "account_roles" {
  source = "../../../resources/aws_iam/roles_account"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  developer_policy_map = {

  }

  assuming_account_ids = var.assuming_account_ids
}
