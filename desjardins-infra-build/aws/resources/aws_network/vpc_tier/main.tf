module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  attributes  = var.attributes
  tags        = merge(var.tags, { Tier = var.name })

  label_order = var.label_order
}

locals {
  cidr_subnet_steps = (
    var.cidr_subnet_steps == null
    ? length(var.availability_zones)
    : var.cidr_subnet_steps
  )
}

resource "aws_subnet" "this" {
  for_each = toset(var.availability_zones)

  availability_zone = each.key

  cidr_block = cidrsubnet(
    var.cidr_block,
    var.cidr_subnet_newbits,
    (
      (var.cidr_subnet_offset * local.cidr_subnet_steps)
      + index(var.availability_zones, each.key)
    )
  )

  map_public_ip_on_launch = var.map_ip_on_launch

  tags = merge(module.label.tags, {
    Name = format("%s-%s", module.label.id, substr(each.key, -1, 1))
  })

  vpc_id = var.vpc_id

  lifecycle {
    ignore_changes = [tags.SubnetType]
  }
}

resource "aws_route_table" "this" {
  for_each = toset(var.availability_zones)

  tags = merge(module.label.tags, {
    Name = format("%s-%s", module.label.id, substr(each.key, -1, 1))
  })
  vpc_id = var.vpc_id
}

resource "aws_route_table_association" "this" {
  for_each = toset(var.availability_zones)

  route_table_id = aws_route_table.this[each.key].id
  subnet_id      = aws_subnet.this[each.key].id
}

resource "aws_route" "nat" {
  for_each = var.map_nat_gateways ? toset(var.availability_zones) : []

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[each.key]
  route_table_id         = aws_route_table.this[each.key].id
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  for_each = var.map_s3_endpoint ? toset(var.availability_zones) : []

  route_table_id  = aws_route_table.this[each.key].id
  vpc_endpoint_id = var.s3_endpoint_id
}

resource "aws_network_acl" "this" {
  subnet_ids = [for o in aws_subnet.this : o.id]
  tags       = module.label.tags
  vpc_id     = var.vpc_id
}

resource "aws_network_acl_rule" "this_egress" {
  cidr_block     = "0.0.0.0/0"
  egress         = true
  protocol       = "-1"
  network_acl_id = aws_network_acl.this.id
  rule_action    = "allow"
  rule_number    = "10000"
}

resource "aws_network_acl_rule" "this_ingress" {
  cidr_block     = "0.0.0.0/0"
  egress         = false
  protocol       = "-1"
  network_acl_id = aws_network_acl.this.id
  rule_action    = "allow"
  rule_number    = "10000"
}
