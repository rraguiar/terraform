data "aws_caller_identity" "this" {}

module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

locals {
  description = var.description == null ? var.description : format("%s assume role policy", module.label.id)

  mfa_condition = var.require_mfa ? [true] : []
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "AssumeRoles"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    dynamic "condition" {
      for_each = local.mfa_condition

      content {
        test     = "BoolIfExists"
        variable = "aws:MultiFactorAuthPresent"
        values   = [condition.value]
      }
    }

    resources = var.role_arns
  }
}

resource "aws_iam_policy" "this" {
  name        = module.label.id
  path        = var.path
  description = local.description
  policy      = data.aws_iam_policy_document.this.json
}
