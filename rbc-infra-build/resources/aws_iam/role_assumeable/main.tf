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
  account_id  = data.aws_caller_identity.this.account_id
  description = var.description == null ? var.description : module.label.id

  signin_url = format("https://signin.aws.amazon.com/switchrole?%s&roleName=%s&displayName=%s", local.account_id, aws_iam_role.this.name, module.label.id)
}

module "assume_role_policy" {
  source = "../../aws_policy/assumeable_role"

  conditions = var.conditions
  principals = var.principals
}

resource "aws_iam_role" "this" {
  name = module.label.id
  path = var.path
  tags = module.label.tags

  assume_role_policy    = module.assume_role_policy.json
  description           = local.description
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary
}

resource "aws_iam_role_policy" "this" {
  for_each = var.policy_map

  name   = each.key
  policy = each.value
  role   = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(var.policy_arns)

  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.this.name
}
