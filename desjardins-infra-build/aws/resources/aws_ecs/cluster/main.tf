module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  attributes  = var.attributes
  tags        = var.tags

  label_order = var.label_order
}

#
# ECS cluster
#
resource "aws_ecs_cluster" "this" {
  name = module.label.tags["Name"]
  tags = module.label.tags

  capacity_providers = var.capacity_providers
}

#
# IAM exec role
#
module "task_execution_role" {
  source = "../../aws_iam/role_assumeable"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = format("%s-exec", var.name)
  tags        = var.tags

  principals = {
    service = [
      "ecs-tasks.amazonaws.com"
    ]
  }

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]

  policy_map = {
    Logs       = data.aws_iam_policy_document.ecs_logs_policy.json
    Containers = data.aws_iam_policy_document.ecs_containers_policy.json
    KmsUsage   = data.aws_iam_policy_document.ecs_kms_policy.json
    SsmGet     = data.aws_iam_policy_document.ecs_ssm_parameter_policy.json
  }
}

data "aws_iam_policy_document" "ecs_logs_policy" {
  statement {
    sid       = "AllowCreateLogGroup"
    actions   = ["logs:CreateLogGroup"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_containers_policy" {
  statement {
    sid = "AllowCrossAccountECR"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_kms_policy" {
  statement {
    sid = "AllowKmsUsage"

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]

    resources = [
      var.secrets_key_arn,
    ]
  }
}

data "aws_iam_policy_document" "ecs_ssm_parameter_policy" {
  statement {
    sid = "AllowSsmGet"

    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter",
    ]

    resources = [
      "*"
    ]
  }
}
