#
# IAM Task role
#
module "task_role" {
  source = "../../../../resources/aws_iam/role_assumeable"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  principals = {
    aws = [
      var.ecs_exec_role_arn
    ],
    service = [
      "ecs-tasks.amazonaws.com",
    ]
  }

  policy_map = {
    KMS     = data.aws_iam_policy_document.ecs_kms_policy.json,
    S3      = data.aws_iam_policy_document.ecs_s3_policy.json,
    Secrets = data.aws_iam_policy_document.ecs_secrets_policy.json,
  }
}

data "aws_iam_policy_document" "ecs_kms_policy" {
  statement {
    sid = "AllowKMS"

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]

    resources = [
      var.storage_key_arn,
      var.secrets_key_arn,
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
      "s3:List*",
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
