output "arn" {
  description = "The ARN assigned by AWS for this policy"
  value       = aws_iam_policy.this.arn
}

output "name" {
  description = "The policy's name"
  value       = aws_iam_policy.this.name
}

output "path" {
  description = "The policy's path"
  value       = aws_iam_policy.this.path
}

output "role_arns" {
  description = "List of AWS roles that may be assumed"
  value       = var.role_arns
}
