output "listeners" {
  description = "The LB listeners"
  value       = aws_lb_listener.this
}

output "target_groups" {
  description = "The LB target group"
  value       = aws_lb_target_group.this
}
