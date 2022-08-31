output "id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "availability_zone_names" {
  description = "List of availability zones"
  value       = var.availability_zones
}

output "cidr_info" {
  description = "Map of CIDR details"
  value = {
    block   = var.cidr_block
    newbits = var.cidr_subnet_newbits
    steps   = var.cidr_subnet_steps
  }
}

output "nat_gateways" {
  description = "Map of AZ to NAT gateways"
  value       = module.nat_gateways.output
}

output "private_subnets" {
  description = "List of private subnets"
  value       = module.private_tier.subnets
}

output "private_route_tables" {
  description = "List of private route tables"
  value       = module.private_tier.route_tables
}

output "public_subnets" {
  description = "List of public subnets"
  value       = module.public_tier.subnets
}

output "public_route_tables" {
  description = "List of public route tables"
  value       = module.public_tier.route_tables
}
