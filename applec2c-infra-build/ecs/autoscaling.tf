# Create an autoscaling group associated to the ECS Cluster. 
resource "aws_autoscaling_group" "asg" {
  name_prefix               = "${var.environment}-${var.customer}-${var.application_name}-ecs-asg"
  vpc_zone_identifier       = [var.private_subnet_id[0], var.private_subnet_id[1]]
  desired_capacity          = var.asg_desired_capacity
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  wait_for_capacity_timeout = "5m"
  tags = [merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-ecs-asg"
      "service_role" = "asg"
    })
    )
  ]
  launch_template {
    id      = aws_launch_template.ecs_node.id
    version = "$Latest"
  }
  lifecycle {
    create_before_destroy = true
  }
}