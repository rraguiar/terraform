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
  description = module.label.id
  security_groups = concat(
    [module.security_group.id],
    var.security_group_ids
  )
}

module "security_group" {
  source = "../../aws_ec2/security_group"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags
  label_order = var.label_order

  vpc_id = var.vpc_id

  rules = var.security_group_rules

  trust_targets = merge({
    default = { type = "egress", cidr_block = "0.0.0.0/0" },
    self    = { type = "ingress", self = true }
  }, var.security_group_targets)
}

resource "aws_efs_file_system" "this" {
  creation_token = module.label.id
  tags           = module.label.tags

  encrypted        = true
  kms_key_id       = var.kms_key_id
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode
}

resource "aws_efs_mount_target" "this" {
  for_each = toset(var.subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  security_groups = local.security_groups
  subnet_id       = each.value
}
