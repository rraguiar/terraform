#
# AWS IAM Person
#
# This module handles creating IAM users for individuals with access to the
# IAM console as well as their associated Group memberships.
#

locals {
  name = var.name
  tags = merge(var.tags, { "Name" = local.name })

  encrypted_password = element(
    concat(aws_iam_user_login_profile.this.*.encrypted_password, list("")),
    0
  )

  keybase_pgp_command = templatefile("${path.module}/templates/keybase_decrypt.sh", {
    password = local.encrypted_password
  })
}

resource "aws_iam_user" "this" {
  count = var.enabled ? 1 : 0

  name                 = local.name
  path                 = var.path
  permissions_boundary = var.permissions_boundary
  force_destroy        = var.force_destroy
  tags                 = local.tags
}

resource "aws_iam_user_login_profile" "this" {
  count = var.enabled && var.login_profile_enabled ? 1 : 0

  user                    = element(aws_iam_user.this.*.name, 0)
  pgp_key                 = var.pgp_key
  password_length         = var.password_length
  password_reset_required = var.password_reset_required

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }
}

resource "aws_iam_user_group_membership" "this" {
  count = var.enabled && length(var.groups) > 0 ? 1 : 0

  user   = element(aws_iam_user.this.*.name, 0)
  groups = var.groups
}

resource "aws_iam_user_ssh_key" "this" {
  count = var.enabled && var.ssh_public_key != null ? 1 : 0

  username   = element(aws_iam_user.this.*.name, 0)
  encoding   = "SSH"
  public_key = var.ssh_public_key
}
