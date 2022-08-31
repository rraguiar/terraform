module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

resource "aws_codecommit_repository" "repo" {
  repository_name = module.label.name
  description     = module.label.id
  default_branch  = var.default_branch
  tags            = module.label.tags
}
