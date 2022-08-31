module "repo" {
  source = "../../../resources/aws_codestar/codecommit"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags
}
