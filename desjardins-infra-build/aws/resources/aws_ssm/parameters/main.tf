module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order         = var.label_order
  regex_replace_chars = "[^a-zA-Z0-9-_/]/"
}

locals {
  description = var.description == null ? module.label.id : var.description
  type        = var.key_arn == null ? "String" : "SecureString"
}

#
# Placeholder parameter
#
resource "aws_ssm_parameter" "secret" {
  for_each = { for k, o in var.parameters : k => o if o.type == "SecureString" }

  name = format("/%s/%s", module.label.stage, each.key)
  tags = merge(
    module.label.tags,
    map("Name", format("%s/%s", module.label.path, each.key)),
    map("Path", format("%s/%s", module.label.path, each.key)),
  )

  description = local.description
  key_id      = var.key_arn
  overwrite   = var.overwrite
  tier        = lookup(each.value, "tier", "Standard")
  type        = each.value.type
  value       = "UNDEFINED"

  lifecycle {
    ignore_changes = [value]
  }
}

#
# Parameter
#
resource "aws_ssm_parameter" "parameter" {
  for_each = { for k, o in var.parameters : k => o if o.type == "String" }

  name = format("/%s/%s", module.label.path, each.key)
  tags = merge(
    module.label.tags,
    map("Name", format("%s/%s", module.label.path, each.key)),
    map("Path", format("%s/%s", module.label.path, each.key)),
  )

  description = local.description
  key_id      = null
  overwrite   = var.overwrite
  tier        = lookup(each.value, "tier", "Standard")
  type        = each.value.type
  value       = each.value.value
}
