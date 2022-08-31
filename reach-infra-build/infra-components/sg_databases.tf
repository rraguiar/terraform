# Create SGs ########################################################################################
# Database server
resource "aws_security_group" "databases" {
  name        = "${var.environment}-${var.customer}-${var.application_name}-databases-sg"
  description = "Security group for ${var.customer} ${var.environment} ${var.application_name} databases"
  vpc_id      = var.vpc_id
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-databases-sg"
      "service_role" = "sg"
      "application_name" = var.application_name
    })
  )
}

resource "aws_security_group_rule" "databases_ingress" {
  count             = length(var.databases_ingress_ip)
  type              = "ingress"
  protocol          = var.databases_ingress_protocol[count.index]
  from_port         = var.databases_ingress_port[count.index]
  to_port           = var.databases_ingress_port[count.index]
  cidr_blocks       = [var.databases_ingress_ip[count.index]]
  description       = var.databases_ingress_description[count.index]
  security_group_id = aws_security_group.databases.id
}

resource "aws_security_group_rule" "databases_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.databases.id
}
