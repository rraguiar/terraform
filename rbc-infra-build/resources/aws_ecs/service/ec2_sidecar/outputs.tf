output "ecs_task_definition" {
  value = aws_ecs_task_definition.this
}

output "ecs_service" {
  value = aws_ecs_service.this
}

output "log_group" {
  value = aws_cloudwatch_log_group.this
}
