#
# ECS Cluster and IAM Execution role
#
output "ecs_cluster" {
  value = module.ecs_cluster.cluster
}

output "ecs_exec_role" {
  value = module.ecs_cluster.exec_role
}
