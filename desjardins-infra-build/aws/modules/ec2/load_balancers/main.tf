locals {
  subnet_mappings_public = [
    for subnet in var.subnet_ids.public :
    { allocation_id = null, subnet_id = subnet }
  ]

  subnet_mappings_private = [
    for subnet in var.subnet_ids.private :
    { allocation_id = null, subnet_id = subnet }
  ]
}

#
# Load Balancer
#
module "lb_instance" {
  source = "../../../resources/aws_ec2/lb_instance"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  access_logs        = var.lb_access_logs
  alias              = var.lb_alias
  idle_timeout       = var.lb_idle_timeout
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  security_group_ids = var.security_group_ids
  subnet_mappings    = var.lb_internal ? local.subnet_mappings_private : local.subnet_mappings_public
}

#
# LB Target Group
#
module "lb_target" {
  source = "../../../resources/aws_ec2/lb_target"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  certificate_arn = var.certificate_arn

  health_check = var.lb_healthcheck

  load_balancer     = module.lb_instance.lb
  load_balancer_arn = module.lb_instance.lb.arn

  listeners = var.lb_listeners
  targets   = var.lb_targets

  vpc_id = var.vpc_id
}
