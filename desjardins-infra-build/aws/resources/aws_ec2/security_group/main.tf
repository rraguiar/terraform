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

resource "aws_security_group" "this" {
  name        = module.label.id
  description = local.description
  tags        = module.label.tags
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = var.revoke_rules_on_delete
}

resource "aws_security_group_rule" "this" {
  for_each = var.rules

  description = format("rule: %s",
    lookup(each.value, "description", each.key)
  )
  security_group_id = aws_security_group.this.id

  #
  # Rule Content
  #
  type = lookup(each.value, "type")

  from_port = lookup(each.value, "from_port", null)
  to_port   = lookup(each.value, "to_port", lookup(each.value, "from_port", null))

  protocol    = lookup(each.value, "protocol", "TCP")
  cidr_blocks = lookup(each.value, "cidr_block", null) == null ? null : [lookup(each.value, "cidr_block", null)]
  self        = lookup(each.value, "self", null)

  source_security_group_id = lookup(each.value, "source_security_group_id", null)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "trust" {
  for_each = var.trust_targets

  description = format("trust: %s",
    lookup(each.value, "description", each.key)
  )
  security_group_id = aws_security_group.this.id

  #
  # Rule Content
  #
  type = lookup(each.value, "type", "ingress")

  from_port = lookup(each.value, "from_port", 0)
  to_port = lookup(each.value, "to_port",
    lookup(each.value, "from_port", 65535)
  )

  protocol    = lookup(each.value, "protocol", "all")
  cidr_blocks = lookup(each.value, "cidr_block", null) == null ? null : [lookup(each.value, "cidr_block", null)]
  self        = lookup(each.value, "self", null)

  source_security_group_id = lookup(each.value, "source_security_group_id", null)

  lifecycle {
    create_before_destroy = true
  }
}
