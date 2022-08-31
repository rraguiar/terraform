module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags
}

resource "aws_ecr_repository" "this" {
  name = module.label.name
  tags = module.label.tags

  image_tag_mutability = var.mutable_tags ? "MUTABLE" : "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}
