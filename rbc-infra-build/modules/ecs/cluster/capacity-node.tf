#
# ECS Node / Private
#
resource "aws_ecs_capacity_provider" "ecs_node_private" {
  name = "node-private"
  tags = module.label.tags

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.asg_arns_private.ecs_node
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = var.target_capacity_private.ecs_node
    }
  }
}

#
# ECS Node / Public
#
resource "aws_ecs_capacity_provider" "ecs_node_public" {
  name = "node-public"
  tags = module.label.tags

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.asg_arns_public.ecs_node
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = var.target_capacity_public.ecs_node
    }
  }
}
