output "network_acl" {
  description = "Network acl"
  value       = aws_network_acl.this
}

output "route_tables" {
  description = "Mapping of az to route tables"
  value       = aws_route_table.this
}

output "subnets" {
  description = "Mapping of az to subnets"
  value       = aws_subnet.this
}
