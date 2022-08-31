output "elastic_ips" {
  description = "Available Elastic IPs"
  value       = aws_eip.this
}
