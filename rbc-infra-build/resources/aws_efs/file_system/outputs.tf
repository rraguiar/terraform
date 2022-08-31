output "arn" {
  description = "The ARN of the EFS file system"
  value       = aws_efs_file_system.this.arn
}

output "id" {
  description = "The ID of the EFS file system"
  value       = aws_efs_file_system.this.id
}

output "dns_name" {
  description = "The DNS name of the EFS file system"
  value       = aws_efs_file_system.this.dns_name
}

output "security_group_id" {
  description = "The ID of the EFS file system security group"
  value       = module.security_group.id
}
