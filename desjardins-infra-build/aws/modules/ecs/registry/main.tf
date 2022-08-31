#
# ECR repositories
#
module "admin" {
  source = "../../../resources/aws_ecs/registry"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "desjardins-staging-admin"
  tags        = var.label.tags

  read_principals  = var.read_principals
  write_principals = var.write_principals
}

module "api" {
  source = "../../../resources/aws_ecs/registry"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "desjardins-staging-api"
  tags        = var.label.tags

  read_principals  = var.read_principals
  write_principals = var.write_principals
}

module "assetstore" {
  source = "../../../resources/aws_ecs/registry"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "desjardins-staging-assetstore"
  tags        = var.label.tags

  read_principals  = var.read_principals
  write_principals = var.write_principals
}

module "maintenance" {
  source = "../../../resources/aws_ecs/registry"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "desjardins-staging-loyalty-maintenance"
  tags        = var.label.tags

  read_principals  = var.read_principals
  write_principals = var.write_principals
}

module "membersite" {
  source = "../../../resources/aws_ecs/registry"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "desjardins-staging-membersite"
  tags        = var.label.tags

  read_principals  = var.read_principals
  write_principals = var.write_principals
}
