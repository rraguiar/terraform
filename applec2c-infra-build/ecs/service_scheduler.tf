resource "aws_ecs_task_definition" "scheduler" {
  family             = "${var.application_name}-scheduler-${var.environment}"
  execution_role_arn = data.aws_iam_role.executionrole.arn

  container_definitions = templatefile("task-definitions/scheduler-task.json", { application_name = var.application_name, aws_region = data.aws_region.current.name, customer = var.customer, environment = var.environment, version = var.ecs_container_version, app_key = trimsuffix(data.aws_secretsmanager_secret_version.app_key.id, "|AWSCURRENT"), db_database = trimsuffix(data.aws_secretsmanager_secret_version.db_database.id, "|AWSCURRENT"), db_host = trimsuffix(data.aws_secretsmanager_secret_version.db_host.id, "|AWSCURRENT"), db_password = trimsuffix(data.aws_secretsmanager_secret_version.db_password.id, "|AWSCURRENT"), db_username = trimsuffix(data.aws_secretsmanager_secret_version.db_username.id, "|AWSCURRENT") })
  #redis_host = trimsuffix(data.aws_secretsmanager_secret_version.redis_host.id, "|AWSCURRENT") })
}

resource "aws_ecs_service" "scheduler" {
  name            = "${var.application_name}-scheduler-${var.environment}"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.scheduler.family

  desired_count = 1

  health_check_grace_period_seconds = 0

  deployment_controller {
    type = "ECS"
  }

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}