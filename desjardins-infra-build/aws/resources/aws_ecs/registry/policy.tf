module "read_principals" {
  source = "../../aws_policy/principals"

  principals = var.read_principals
}

module "write_principals" {
  source = "../../aws_policy/principals"

  principals = var.write_principals
}

locals {
  read_enabled  = module.read_principals.total > 0
  write_enabled = module.write_principals.total > 0

  empty_policy = data.aws_iam_policy_document.empty.json
  read_policy  = data.aws_iam_policy_document.read.json
  write_policy = data.aws_iam_policy_document.write.json
}

data "aws_iam_policy_document" "empty" {}

data "aws_iam_policy_document" "read" {
  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    dynamic "principals" {
      for_each = module.read_principals.data

      content {
        type        = principals.key
        identifiers = principals.value
      }
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]
  }
}

data "aws_iam_policy_document" "write" {
  statement {
    sid    = "FullAccess"
    effect = "Allow"

    dynamic "principals" {
      for_each = module.write_principals.data

      content {
        type        = principals.key
        identifiers = principals.value
      }
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]
  }
}

data "aws_iam_policy_document" "this" {
  source_json   = local.read_enabled ? local.read_policy : local.empty_policy
  override_json = local.write_enabled ? local.write_policy : local.empty_policy
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.this.json
}
