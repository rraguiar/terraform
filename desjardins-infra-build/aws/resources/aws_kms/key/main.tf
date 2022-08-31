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
  description = var.description == null ? module.label.id : var.description
}

resource "aws_kms_key" "this" {
  description = local.description
  policy      = var.policy
  tags        = module.label.tags

  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
}

resource "aws_kms_alias" "this" {
  name          = format("alias/%s", module.label.id)
  target_key_id = aws_kms_key.this.id
}
