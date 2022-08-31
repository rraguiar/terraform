output "arn" {
  description = "The ARN of the EFS access point"
  value       = aws_efs_access_point.this.arn
}

output "id" {
  description = "The ID of the EFS access point"
  value       = aws_efs_access_point.this.id
}
