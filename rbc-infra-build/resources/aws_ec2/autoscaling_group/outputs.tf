output "autoscaling_group" {
  description = "The ARN of the autoscaling group"
  value       = aws_autoscaling_group.this
}

output "launch_template" {
  description = "The name of the launch template"
  value       = aws_launch_template.this
}

output "security_group" {
  description = "The arn of the instance security group"
  value       = module.security_group
}
