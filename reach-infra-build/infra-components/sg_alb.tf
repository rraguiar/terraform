# Create SGs ########################################################################################
# Load Balancer
resource "aws_security_group" "alb" {
  name        = "${var.environment}-${var.customer}-${var.application_name}-lb-sg"
  description = "Security group for ${var.customer} ${var.environment} ${var.application_name} Load Balancer"
  vpc_id      = var.vpc_id
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-lb-sg"
      "service_role" = "sg"
      "application_name" = var.application_name
    })
  )
}

resource "aws_security_group_rule" "alb_ingress" {
  count             = length(var.alb_ingress_protocol)
  type              = "ingress"
  protocol          = var.alb_ingress_protocol[count.index]
  from_port         = var.alb_ingress_port[count.index]
  to_port           = var.alb_ingress_port[count.index]
  cidr_blocks       = [var.alb_ingress_ip[count.index]]
  description       = var.alb_ingress_description[count.index]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}