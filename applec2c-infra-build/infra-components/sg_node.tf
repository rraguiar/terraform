# Create SGs ########################################################################################
# Node server
resource "aws_security_group" "node" {
  name        = "${var.environment}-${var.customer}-${var.application_name}-node-sg"
  description = "Security group for ${var.customer} ${var.environment} ${var.application_name} node"
  vpc_id      = var.vpc_id
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-node-sg"
      "service_role" = "sg"
      "application_name" = var.application_name
    })
  )
}

resource "aws_security_group_rule" "node_ingress" {
  count             = length(var.node_ingress_protocol)
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = [var.node_ingress_ip[count.index]]
  description       = var.node_ingress_description[count.index]
  security_group_id = aws_security_group.node.id
}

resource "aws_security_group_rule" "node_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.node.id
}