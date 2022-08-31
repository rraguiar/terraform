resource "aws_ecs_cluster" "ecs" {
  name = "${var.environment}-${var.customer}-${var.application_name}-ecs-cluster"
}