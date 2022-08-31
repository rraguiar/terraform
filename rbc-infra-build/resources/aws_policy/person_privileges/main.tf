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
  aws_account_id = data.aws_caller_identity.this.account_id
  description    = var.description == null ? var.description : format("Default user policy")
}

#
# Generate ARNs for user and mfa device
#
module "aws_arn_user" {
  source = "../../aws_data/arn"

  service = "iam"
  account = local.aws_account_id
  path    = ["user", "$${aws:username}"]
}

module "aws_arn_mfa-all" {
  source = "../../aws_data/arn"

  service = "iam"
  account = local.aws_account_id
  path    = ["mfa", "*"]
}

module "aws_arn_mfa-user" {
  source = "../../aws_data/arn"

  service = "iam"
  account = local.aws_account_id
  path    = ["mfa", "$${aws:username}"]
}

#
# Policy Document
#
data "aws_iam_policy_document" "this" {
  statement {
    sid = "AllowViewAccount"

    actions = [
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary",
      "iam:ListAccountAliases",
      "iam:ListUsers",
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = "AllowSelfManagePassword"

    actions = [
      "iam:ChangePassword",
      "iam:CreateLoginProfile",
      "iam:DeleteLoginProfile",
      "iam:GetLoginProfile",
      "iam:UpdateLoginProfile",
    ]

    effect = "Allow"

    resources = [module.aws_arn_user.arn]
  }

  statement {
    sid = "AllowSelfManageAccessKey"

    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:GetAccessKeyLastUsed",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey",
    ]

    effect = "Allow"

    resources = [module.aws_arn_user.arn]
  }

  statement {
    sid = "AllowSelfListMFA"

    actions = [
      "iam:ListVirtualMFADevices",
      "iam:ListMFADevices",
    ]

    effect = "Allow"

    resources = [
      module.aws_arn_mfa-all.arn,
      module.aws_arn_user.arn,
    ]
  }

  statement {
    sid = "AllowSelfManageMFA"

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeactivateMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
    ]

    effect = "Allow"

    resources = [
      module.aws_arn_mfa-user.arn,
      module.aws_arn_user.arn,
    ]
  }

  statement {
    sid = "AllowSelfManageSSH"

    actions = [
      "iam:ListSSHPublicKeys",
      "iam:GetSSHPublicKey",
      "iam:DeleteSSHPublicKey",
      "iam:UpdateSSHPublicKey",
      "iam:UploadSSHPublicKey",
    ]

    effect = "Allow"

    resources = [
      module.aws_arn_user.arn,
    ]
  }

  statement {
    sid    = "RequireMFAForAllExceptSomeIAM"
    effect = "Deny"

    not_actions = [
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary",
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:ChangePassword",
      "iam:CreateLoginProfile",
      "iam:DeleteLoginProfile",
      "iam:GetLoginProfile",
      "iam:UpdateLoginProfile",
      "iam:ListVirtualMFADevices",
      "iam:ListMFADevices",
      "iam:CreateVirtualMFADevice",
      "iam:DeactivateMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "sts:AssumeRole",
    ]

    resources = ["*"]

    condition {
      test     = "Null"
      variable = "aws:MultiFactorAuthAge"
      values   = ["true"]
    }
  }
}

#
# IAM policy
#
resource "aws_iam_policy" "this" {
  name        = module.label.id
  path        = var.path
  description = local.description
  policy      = data.aws_iam_policy_document.this.json
}
