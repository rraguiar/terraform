module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  attributes  = var.attributes
  tags        = var.tags

  label_order = var.label_order
}

#
# ECS cluster
#
resource "aws_ecs_cluster" "this" {
  name = module.label.tags["Name"]
  tags = module.label.tags

  capacity_providers = var.capacity_providers
}
