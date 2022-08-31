output "output" {
  description = "Map of subnet to NAT gateways"
  value       = aws_nat_gateway.this
}
