locals {
  default = {
    account_ids    = [var.account_id]
    aws            = []
    canonical_user = []
    federated      = []
    service        = []
  }

  principals = {
    owner = merge(local.default,
      lookup(var.policy_principals, "owner", {})
    )
    decrypt = merge(local.default,
      lookup(var.policy_principals, "decrypt", {})
    )
    encrypt = merge(local.default,
      lookup(var.policy_principals, "encrypt", {})
    )
    grant = merge(local.default,
      lookup(var.policy_principals, "grant", {})
    )
  }
}

module "owner_principals" {
  source = "../../aws_policy/principals"

  account_ids    = local.principals.owner.account_ids
  aws            = local.principals.owner.aws
  canonical_user = local.principals.owner.canonical_user
  federated      = local.principals.owner.federated
  service        = local.principals.owner.service
}

module "decrypt_principals" {
  source = "../../aws_policy/principals"

  account_ids    = local.principals.decrypt.account_ids
  aws            = local.principals.decrypt.aws
  canonical_user = local.principals.decrypt.canonical_user
  federated      = local.principals.decrypt.federated
  service        = local.principals.decrypt.service
}

module "encrypt_principals" {
  source = "../../aws_policy/principals"

  account_ids    = local.principals.encrypt.account_ids
  aws            = local.principals.encrypt.aws
  canonical_user = local.principals.encrypt.canonical_user
  federated      = local.principals.encrypt.federated
  service        = local.principals.encrypt.service
}

module "grant_principals" {
  source = "../../aws_policy/principals"

  account_ids    = local.principals.grant.account_ids
  aws            = local.principals.grant.aws
  canonical_user = local.principals.grant.canonical_user
  federated      = local.principals.grant.federated
  service        = local.principals.grant.service
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "ManageWithKey"

    actions = [
      "kms:*"
    ]

    effect = "Allow"

    dynamic "principals" {
      for_each = module.owner_principals.data
      iterator = owner_principals

      content {
        type        = owner_principals.key
        identifiers = owner_principals.value
      }
    }

    resources = [
      "*"
    ]
  }

  statement {
    sid = "DecryptWithKey"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
    ]

    effect = "Allow"

    dynamic "principals" {
      for_each = module.decrypt_principals.data
      iterator = decrypt_principals

      content {
        type        = decrypt_principals.key
        identifiers = decrypt_principals.value
      }
    }

    resources = [
      "*"
    ]
  }

  statement {
    sid = "EncryptWithKey"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    effect = "Allow"

    dynamic "principals" {
      for_each = module.encrypt_principals.data
      iterator = encrypt_principals

      content {
        type        = encrypt_principals.key
        identifiers = encrypt_principals.value
      }
    }

    resources = [
      "*"
    ]
  }

  statement {
    sid = "GrantWithKey"

    actions = [
      "kms:CreateGrant"
    ]

    effect = "Allow"

    dynamic "principals" {
      for_each = module.grant_principals.data
      iterator = grant_principals

      content {
        type        = grant_principals.key
        identifiers = grant_principals.value
      }
    }

    resources = [
      "*"
    ]
  }
}
