#
# IAM service role
#
module "service_role" {
  source = "../../../resources/aws_iam/role_assumeable"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  principals = {
    service = [
      "codebuild.amazonaws.com"
    ]
  }

  policy_map = {
    AllowCloudwatch = data.aws_iam_policy_document.cloudwatch_policy.json
    AllowEc2        = data.aws_iam_policy_document.ec2_policy.json
    AllowKms        = data.aws_iam_policy_document.kms_policy.json
    AllowSSM        = data.aws_iam_policy_document.ssm_policy.json
    AllowECR        = data.aws_iam_policy_document.ecr_policy.json
    AllowCodeCommit = data.aws_iam_policy_document.codecommit_policy.json
    AllowCodeBuild  = data.aws_iam_policy_document.codebuild_policy.json
  }
}

#
# IAM Policies
#
data "aws_iam_policy_document" "cloudwatch_policy" {
  statement {
    effect    = "Allow"
    sid       = "AllowCloudwatchLogs"
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}

data "aws_iam_policy_document" "ec2_policy" {
  statement {
    effect    = "Allow"
    sid       = "AllowEC2Networking"
    resources = ["*"]
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]
  }

  statement {
    effect    = "Allow"
    sid       = "AllowEC2ENIPermissions"
    resources = ["*"]
    actions = [
      "ec2:CreateNetworkInterfacePermission"
    ]
  }
}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid    = "AllowKMS"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = [
      var.secrets_key_arn
    ]
  }
}

data "aws_iam_policy_document" "ssm_policy" {
  statement {
    sid    = "AllowSSM"
    effect = "Allow"
    actions = [
      "ssm:GetParameters"
    ]
    resources = [
      format("arn:aws:ssm:%s:%s:parameter/%s/%s/*", var.aws.region, var.aws.account_id, var.label.stage, var.label.namespace)
    ]
  }
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    sid    = "AllowECR"
    effect = "Allow"
    actions = [
      "ecr:CreateRepository",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "codecommit_policy" {
  statement {
    sid    = "AllowCodeCommit"
    effect = "Allow"
    actions = [
      "codecommit:GitPull"
    ]
    resources = [
      format("arn:aws:codecommit:%s:%s:*", var.aws.region, var.aws.account_id)
    ]
  }
}

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    sid    = "AllowCodeCommit"
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      format("arn:aws:codebuild:%s:%s:report-group/*", var.aws.region, var.aws.account_id)
    ]
  }
}
