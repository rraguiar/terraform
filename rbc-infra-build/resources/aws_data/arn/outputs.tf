output "partition" {
  description = "The partition that the resource is in"
  value       = var.partition
}

output "service" {
  description = "The service namespace that identifies the AWS product"
  value       = var.service
}

output "region" {
  description = "The Region that the resource resides in"
  value       = var.region
}

output "account" {
  description = "The ID of the AWS account that owns the resource, without the hyphens"
  value       = var.account
}

output "path" {
  description = "The path of the resource"
  value       = local.path
}

output "arn" {
  description = "The constructed ARN"
  value       = local.arn
}
