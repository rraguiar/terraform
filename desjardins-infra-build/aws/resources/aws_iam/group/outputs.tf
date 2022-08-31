output "arn" {
  description = "The ARN assigned by AWS for this group"
  value       = aws_iam_group.this.arn
}

output "name" {
  description = "The group's name"
  value       = aws_iam_group.this.name
}
