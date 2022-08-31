#
# SSM Parameters
#
module "parameters" {
  source = "../../../resources/aws_ssm/parameters"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  key_arn    = var.secrets_key_arn
  parameters = var.parameters
}
