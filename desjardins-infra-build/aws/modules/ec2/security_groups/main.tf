#
# Security Group
#
module "security_group" {
  source = "../../../resources/aws_ec2/security_group"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  vpc_id = var.vpc_id

  rules = var.security_group_rules

  trust_targets = merge({
    default = { type = "egress", cidr_block = "0.0.0.0/0" },
    self    = { type = "ingress", self = true }
  }, var.security_group_targets)
}
