# EC2
# Define IAM Policy Template Files ##################################################################
data "template_file" "deploy_policy" {
  template = file("../templates/${var.environment}-${var.customer}-${var.application_name}-deploy-policy.tpl")
}

data "template_file" "deploy_sts_assumerole" {
  template = file("../templates/${var.environment}-${var.customer}-${var.application_name}-deploy-sts-assumlerole.tpl")
}

# Create the IAM Role ###############################################################################
resource "aws_iam_role" "deploy" {
  name               = "${var.environment}-${var.customer}-${var.application_name}-deploy-role"
  description        = "IAM Role and Instance Profile for ${var.customer} ${var.environment} deploy server"
  assume_role_policy = data.template_file.deploy_sts_assumerole.rendered
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-deploy-role"
      "service_role" = "role"
      "application_name" = var.application_name
    })
  )
}

# Create the IAM Policy #############################################################################
resource "aws_iam_policy" "deploy" {
  name        = "${var.environment}-${var.customer}-${var.application_name}-deploy-policy"
  description = "IAM Policy for ${var.customer} ${var.environment} deploy server"
  policy      = data.template_file.deploy_policy.rendered
  depends_on  = [aws_iam_role.deploy]
}

# Create the IAM Role Instance Profile ##############################################################
resource "aws_iam_instance_profile" "deploy" {
  name       = "${var.environment}-${var.customer}-${var.application_name}-deploy-role"
  role       = aws_iam_role.deploy.name
  depends_on = [aws_iam_role.deploy]
}

# Attach the Policy to the Role #####################################################################
resource "aws_iam_role_policy_attachment" "deploy" {
  role       = aws_iam_role.deploy.name
  policy_arn = aws_iam_policy.deploy.arn
}

# ECS
# Define IAM Policy Template Files ##################################################################
data "template_file" "ecs_policy" {
  template = file("../templates/${var.environment}-${var.customer}-${var.application_name}-ecs-policy.tpl")
}

data "template_file" "ecs_sts_assumerole" {
  template = file("../templates/${var.environment}-${var.customer}-${var.application_name}-ecs-sts-assumlerole.tpl")
}

resource "aws_iam_role" "ecs" {
  name               = "${var.environment}-${var.customer}-${var.application_name}-ecs-TaskExecutionRole"
  description        = "IAM Role for ECS Task Execution"
  assume_role_policy = data.template_file.ecs_sts_assumerole.rendered
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-ecs-TaskExecutionRole"
      "service_role" = "role"
      "application_name" = var.application_name
    })
  )
  depends_on = [aws_s3_bucket.bucket]
}

resource "aws_iam_policy" "ecs" {
  name        = "${var.environment}-${var.customer}-${var.application_name}-ecs-TaskExecutionPolicy"
  description = "IAM Policy for ECS Task Execution Role"
  policy      = data.template_file.ecs_policy.rendered
  depends_on  = [aws_iam_role.ecs]
}

resource "aws_iam_role_policy_attachment" "taskexecutionattachment" {
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.ecs.arn
}

resource "aws_iam_role_policy_attachment" "ecstaskexecutionattachment" {
  role       = aws_iam_role.ecs.name
  policy_arn = data.aws_iam_policy.ecs_task_execution.arn
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}