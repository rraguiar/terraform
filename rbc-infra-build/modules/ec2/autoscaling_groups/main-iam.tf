#
# IAM / EC2 Instance Role
#
module "instance_role" {
  source = "../../../resources/aws_iam/role_assumeable"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = format("%s-instance", var.label.name)
  tags        = var.label.tags

  principals = {
    service = [
      "ec2.amazonaws.com",
    ]
  }

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  policy_map = {
    ECR  = data.aws_iam_policy_document.ecr_policy.json
    ECS  = data.aws_iam_policy_document.ecs_policy.json
    IAM  = data.aws_iam_policy_document.iam_policy.json
    Logs = data.aws_iam_policy_document.logs_policy.json
  }
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    sid = "AllowECR"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:GetAuthorizationToken",
      "ecr:UploadLayerPart",
      "ecr:ListImages",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_policy" {
  statement {
    sid = "AllowECS"
    actions = [
      "ecs:RegisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:CreateCluster",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecs:DescribeTaskDefinition",
      "ecs:Poll",
      "ecs:UpdateService",
      "ecs:RunTask",
      "ecs:StartTelemetrySession",
      "ecs:RegisterTaskDefinition",
      "ecs:DescribeServices",
      "ecs:ListTaskDefinitions",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "iam_policy" {
  statement {
    sid = "AllowIAM"
    actions = [
      "iam:PassRole",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "logs_policy" {
  statement {
    sid = "AllowLogs"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:FilterLogEvents",
    ]
    resources = ["*"]
  }
}
