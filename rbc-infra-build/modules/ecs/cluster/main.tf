module "label" {
  source = "../../../resources/aws_data/label"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name

  label_order = ["stage", "namespace", "environment", "name"]
}

#
# ECS Cluster
#
module "ecs_cluster" {
  source = "../../../resources/aws_ecs/cluster"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  s3_bucket_arns  = var.s3_bucket_arns
  secrets_key_arn = var.secrets_key_arn
  storage_key_arn = var.storage_key_arn

  capacity_providers = [
    "FARGATE",
    # "FARGATE_SPOT",
    aws_ecs_capacity_provider.ecs_node_private.name,
    aws_ecs_capacity_provider.ecs_node_public.name,
  ]
}
