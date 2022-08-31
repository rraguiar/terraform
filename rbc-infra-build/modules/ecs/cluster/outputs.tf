#
# ECS Cluster
#
output "ecs_cluster" {
  value = module.ecs_cluster.cluster
}

#
# IAM Execution role
#
output "ecs_exec_role" {
  value = module.ecs_cluster.exec_role
}

#
# Capacity Providers
#
output "capacity_providers" {
  value = {
    public = {
      ecs_node = aws_ecs_capacity_provider.ecs_node_public
    },
    private = {
      ecs_node = aws_ecs_capacity_provider.ecs_node_private
    }
  }
}
