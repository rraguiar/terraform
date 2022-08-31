locals {
  health_check = merge({
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }, var.health_check)

  flattened_targets = flatten([
    for t, target_list in var.targets : [
      for target in target_list : {
        target_id       = t,
        target_port     = target.port,
        target_protocol = target.protocol,
        target_type     = target.type,
  }]])

  flattened_listeners = flatten([
    for l, listener_list in var.listeners : [
      for listener in listener_list : {
        listener_id       = l,
        listener_port     = listener.port,
        listener_protocol = listener.protocol,
  }]])
}

module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags
  attributes  = var.attributes

  label_order = var.label_order
}

resource "aws_lb_target_group" "this" {
  for_each = {
    for t in local.flattened_targets : t.target_id => t
  }

  name = format("%s-${substr(uuid(), 0, 3)}", module.label.id)
  tags = module.label.tags

  deregistration_delay = var.deregistration_delay
  port                 = each.value.target_port
  protocol             = each.value.target_protocol
  proxy_protocol_v2    = var.proxy_protocol_v2
  target_type          = each.value.target_type
  vpc_id               = var.vpc_id

  # https://github.com/cds-snc/aws-ecs-fargate/issues/1
  depends_on = [var.load_balancer]

  # https://github.com/terraform-providers/terraform-provider-aws/issues/636
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }

  health_check {
    enabled             = local.health_check.enabled
    interval            = local.health_check.interval
    path                = local.health_check.path
    port                = local.health_check.port
    protocol            = local.health_check.protocol
    healthy_threshold   = local.health_check.healthy_threshold
    unhealthy_threshold = local.health_check.unhealthy_threshold
  }
}

resource "aws_lb_listener" "this" {
  for_each = {
    for l in local.flattened_listeners : l.listener_port => l
  }

  load_balancer_arn = var.load_balancer_arn
  port              = each.key
  protocol          = each.value.listener_protocol

  certificate_arn = (
    each.value.listener_protocol == "HTTPS"
    ? var.certificate_arn
    : null
  )

  ssl_policy = (
    each.value.listener_protocol == "HTTPS"
    ? var.ssl_policy
    : null
  )

  default_action {
    target_group_arn = aws_lb_target_group.this[each.value.listener_id].arn
    type             = "forward"
  }
}
