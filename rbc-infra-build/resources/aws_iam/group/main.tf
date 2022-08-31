#
# AWS IAM Group
#
# This module handles creating IAM groups for individuals and binds the
# associated policies.
#
# NOTE: Group memberships will NOT be handled on this resource.
#       We are instead doing so in the User resources, which would
#       otherwise overlap with this functionality.
#

module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

resource "aws_iam_group" "this" {
  name = module.label.id
  path = var.path
}

resource "aws_iam_group_policy_attachment" "this" {
  count = length(var.policy_arns)

  group      = aws_iam_group.this.name
  policy_arn = var.policy_arns[count.index]
}
