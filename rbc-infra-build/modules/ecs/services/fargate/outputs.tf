output "ecs_service" {
  value     = module.ecs_service.ecs_service
  sensitive = true
}

output "ecs_task_definition" {
  value = module.ecs_service.ecs_task_definition
}

output "ecs_log_group" {
  value = module.ecs_service.log_group
}

output "task_role" {
  value = module.task_role
}

output "autoscaling_policy" {
  value = {
    cpu = aws_appautoscaling_policy.this-cpu
    mem = aws_appautoscaling_policy.this-mem
  }
}

output "autoscaling_target" {
  value = aws_appautoscaling_target.this
}
