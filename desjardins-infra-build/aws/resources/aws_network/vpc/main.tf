module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  attributes  = var.attributes
  tags        = var.tags

  label_order = var.label_order
}

#
# VPC
#
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = module.label.tags
}

#
# VPC DHCP options
#
resource "aws_vpc_dhcp_options" "this" {
  domain_name_servers = ["AmazonProvidedDNS"]
  tags                = module.label.tags
}

resource "aws_vpc_dhcp_options_association" "this" {
  dhcp_options_id = aws_vpc_dhcp_options.this.id
  vpc_id          = aws_vpc.this.id
}

#
# VPC Internet Gateway
#
resource "aws_internet_gateway" "this" {
  tags   = module.label.tags
  vpc_id = aws_vpc.this.id
}

#
# VPC NAT gateways
#
module "nat_gateways" {
  source = "../vpc_gateways"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = module.label.tags
  label_order = var.label_order

  elastic_ips = var.elastic_ips
  subnet_map = zipmap(
    var.availability_zones,
    [for o in module.public_tier.subnets : o.id],
  )
}

#
# Public subnet
#
module "public_tier" {
  source = "../vpc_tier"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = "public"
  tags        = var.tags

  availability_zones = var.availability_zones

  cidr_block          = var.cidr_block
  cidr_subnet_newbits = var.cidr_subnet_newbits
  cidr_subnet_offset  = 0
  cidr_subnet_steps   = var.cidr_subnet_steps

  map_ip_on_launch = true

  //  map_s3_endpoint = true
  //  s3_endpoint_id  = aws_vpc_endpoint.s3.id

  vpc_id = aws_vpc.this.id
}

resource "aws_route" "public" {
  for_each = toset(var.availability_zones)

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  route_table_id         = module.public_tier.route_tables[each.key].id
}

module "private_tier" {
  source = "../vpc_tier"

  namespace   = module.label.namespace
  stage       = module.label.stage
  environment = module.label.environment
  name        = "private"
  tags        = module.label.tags

  availability_zones = var.availability_zones

  cidr_block          = var.cidr_block
  cidr_subnet_newbits = var.cidr_subnet_newbits
  cidr_subnet_offset  = 1
  cidr_subnet_steps   = var.cidr_subnet_steps

  map_nat_gateways = true
  nat_gateway_ids  = { for k, o in module.nat_gateways.output : k => o.id }

  //  map_s3_endpoint = true
  //  s3_endpoint_id  = module.vpc.s3_endpoint_id

  vpc_id = aws_vpc.this.id
}