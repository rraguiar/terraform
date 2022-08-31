module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

#
# Secrets Manager
#
resource "aws_secretsmanager_secret" "this" {
  name                    = var.name
  description             = var.name
  kms_key_id              = var.secrets_key_arn
  recovery_window_in_days = 0
  tags                    = module.label.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_string

  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}

#
# Policy
#
resource "aws_secretsmanager_secret_policy" "this" {
  secret_arn = aws_secretsmanager_secret.this.arn
  policy     = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = ["*"]
  }
}
