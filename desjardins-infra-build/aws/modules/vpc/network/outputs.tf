output "route_table_ids" {
  description = "Map of tier to route table ids"
  value = {
    private = [for k, o in module.vpc.private_route_tables : o.id],
    public  = [for k, o in module.vpc.public_route_tables : o.id],
  }
}

output "subnet_ids" {
  description = "Map of tier to subnet ids"
  value = {
    private = [for k, o in module.vpc.private_subnets : o.id],
    public  = [for k, o in module.vpc.public_subnets : o.id],
  }
}

output "subnet_ids_slice" {
  description = "Map of tier to subnet ids, slice of first two elements"
  value = {
    private = slice([for k, o in module.vpc.private_subnets : o.id], 0, 2),
    public  = slice([for k, o in module.vpc.public_subnets : o.id], 0, 2),
  }
}

output "subnet_cidrs" {
  description = "Map of tier to subnet CIDR range"
  value = {
    private = [for k, o in module.vpc.private_subnets : o.cidr_block],
    public  = [for k, o in module.vpc.public_subnets : o.cidr_block],
  }
}

output "vpc" {
  description = "The VPC info"
  value = {
    id        = module.vpc.id
    cidr_info = module.vpc.cidr_info
  }
}
