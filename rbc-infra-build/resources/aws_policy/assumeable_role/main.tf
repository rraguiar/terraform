data "aws_caller_identity" "this" {}

module "principals" {
  source = "../principals"

  account_ids    = local.principals.account
  aws            = local.principals.aws
  canonical_user = local.principals.canonical_user
  federated      = local.principals.federated
  service        = local.principals.service
}


locals {
  principals = merge({
    account        = []
    aws            = []
    canonical_user = []
    federated      = []
    service        = []
  }, var.principals)
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = var.actions
    effect  = "Allow"

    dynamic "condition" {
      for_each = var.conditions

      content {
        test     = condition.value.test
        values   = condition.value.values
        variable = condition.value.variable
      }
    }

    dynamic "principals" {
      for_each = module.principals.data

      content {
        type        = principals.key
        identifiers = principals.value
      }
    }
  }
}
