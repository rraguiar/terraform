module "project" {
  source = "../../../resources/aws_codestar/codebuild"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  env_vars = var.env_vars

  service_role_arn = module.service_role.arn
  source_location  = var.source_location

  security_group_ids = var.security_group_ids
  subnet_ids         = var.subnet_ids
  vpc_id             = var.vpc_id
}
