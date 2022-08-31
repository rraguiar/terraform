module "label" {
  source = "../../../resources/aws_data/label"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name

  label_order = ["namespace", "environment"]
}

#
# ECS Cluster
#
module "ecs_cluster" {
  source = "../../../resources/aws_ecs/cluster"

  namespace   = module.label.namespace
  stage       = module.label.stage
  environment = module.label.environment
  name        = module.label.name
  tags        = module.label.tags

  capacity_providers = [
    "FARGATE"
  ]

  secrets_key_arn = var.secrets_key_arn
}
