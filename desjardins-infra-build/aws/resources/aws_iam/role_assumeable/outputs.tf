output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the role"
  value       = aws_iam_role.this.arn
}

output "name" {
  description = "The name of the role"
  value       = aws_iam_role.this.name
}

output "path" {
  description = "The name of the role"
  value       = format("%s%s", var.path, aws_iam_role.this.name)
}

output "signin_url" {
  description = "The signin url for the role"
  value       = local.signin_url
}
