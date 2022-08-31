output "id" {
  value = aws_ecs_cluster.this.id
}

output "cluster" {
  value = aws_ecs_cluster.this
}

output "exec_role" {
  value = module.task_execution_role
}
