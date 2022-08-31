output "alias" {
  description = "The Route53 Alias of the load balancer"
  value       = (var.alias == null ? null : aws_route53_record.this[0].fqdn)
}

output "arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.this.arn
}

output "lb" {
  description = "The load balancer object."
  value       = aws_lb.this
}

output "fqdn" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}

output "subnet_ids" {
  description = "List of subnet ids the load balanced is deployed to"
  value       = [for m in var.subnet_mappings : m.subnet_id]
}

output "zone_id" {
  description = "The Route53 hosted zone id"
  value       = aws_lb.this.zone_id
}
