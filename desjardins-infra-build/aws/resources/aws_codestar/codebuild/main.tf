module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

resource "aws_codebuild_project" "this" {
  name          = module.label.name
  description   = module.label.name
  build_timeout = var.build_timeout
  service_role  = var.service_role_arn
  tags          = module.label.tags

  artifacts {
    type = var.artifacts_type
  }

  dynamic "cache" {
    for_each = var.cache

    content {
      type     = lookup(cache.value, "type", null)
      location = lookup(cache.value, "location", null)
      modes    = lookup(cache.value, "modes", null)
    }
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = var.type
    image_pull_credentials_type = var.image_pull_credentials_type
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.env_vars

      content {
        name  = lookup(environment_variable.value, "name", null)
        value = lookup(environment_variable.value, "value", null)
        type  = lookup(environment_variable.value, "type", null)
      }
    }
  }

  source {
    type            = var.source_type
    location        = var.source_location
    git_clone_depth = var.source_git_clone_depth

    git_submodules_config {
      fetch_submodules = var.source_git_submodules_config
    }
  }

  source_version = var.source_version

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
}