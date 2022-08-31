locals {
  idle_timeout = (var.load_balancer_type == "application" ? var.idle_timeout : null)
}

module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

#
# Load Balancer
#
resource "aws_lb" "this" {
  name = module.label.id
  tags = module.label.tags

  dynamic "access_logs" {
    for_each = var.access_logs.enabled ? [var.access_logs] : []
    iterator = a

    content {
      bucket  = a.value.bucket
      prefix  = a.value.prefix
      enabled = a.value.enabled
    }
  }

  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  internal           = var.internal
  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
  idle_timeout       = local.idle_timeout

  security_groups = var.security_group_ids

  dynamic "subnet_mapping" {
    for_each = var.subnet_mappings

    content {
      allocation_id = lookup(subnet_mapping.value, "allocation_id", null)
      subnet_id     = lookup(subnet_mapping.value, "subnet_id")
    }
  }

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

#
# Route 53 record
#
resource "aws_route53_record" "this" {
  count = var.alias == null ? 0 : 1

  name    = var.alias.fqdn
  type    = "A"
  zone_id = var.alias.zone_id

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = false
  }
}
