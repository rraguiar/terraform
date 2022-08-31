output "ecs_service" {
  value = module.ecs_service.ecs_service
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
