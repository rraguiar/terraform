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
    KMS        = data.aws_iam_policy_document.ecs_kms_policy.json
    Secrets    = data.aws_iam_policy_document.ecs_secrets_policy.json
    S3         = data.aws_iam_policy_document.ecs_s3_policy.json
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
      var.storage_key_arn
    ]
  }
}

data "aws_iam_policy_document" "ecs_s3_policy" {
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/taskdef-envfiles.html # Required IAM Permissions
  statement {
    sid    = "AllowRead"
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = concat(
      var.s3_bucket_arns,
      formatlist("%s/*", var.s3_bucket_arns)
    )
  }
}

data "aws_iam_policy_document" "ecs_secrets_policy" {
  statement {
    sid = "AllowSecrets"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:ListSecrets",
    ]
    resources = [
      "*"
    ]
  }
}
