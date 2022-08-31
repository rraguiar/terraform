#
# Secrets
#
module "secrets" {
  for_each = var.secrets

  source = "../../resources/aws_secrets_manager/secret"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = each.key
  tags        = var.label.tags

  secrets_key_arn = var.secrets_key_arn
  secret_string   = each.value
}
