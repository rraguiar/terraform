# Create SGs ########################################################################################
# Deploy server
resource "aws_security_group" "deploy" {
  name        = "${var.environment}-${var.customer}-${var.application_name}-deploy-sg"
  description = "Security group for ${var.customer} ${var.environment} ${var.application_name} deploy"
  vpc_id      = var.vpc_id
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-deploy-sg"
      "service_role" = "sg"
      "application_name" = var.application_name
    })
  )
}

resource "aws_security_group_rule" "deploy_ingress" {
  count             = length(var.deploy_ingress_protocol)
  type              = "ingress"
  protocol          = var.deploy_ingress_protocol[count.index]
  from_port         = var.deploy_ingress_from_port[count.index]
  to_port           = var.deploy_ingress_to_port[count.index]
  cidr_blocks       = [var.deploy_ingress_ip[count.index]]
  description       = var.deploy_ingress_description[count.index]
  security_group_id = aws_security_group.deploy.id
}

resource "aws_security_group_rule" "deploy_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.deploy.id
}