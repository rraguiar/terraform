output "iam_role_arns" {
  description = "Map of IAM roles"
  value       = local.arns
}

output "iam_role_names" {
  description = "Map of IAM roles"
  value       = local.names
}
