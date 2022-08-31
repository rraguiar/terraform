module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

resource "aws_efs_access_point" "this" {
  file_system_id = var.file_system_id

  posix_user {
    gid            = var.posix_user.gid
    uid            = var.posix_user.uid
    secondary_gids = var.posix_user.secondary_gids
  }

  root_directory {
    path = var.root_directory

    creation_info {
      owner_gid   = var.posix_user.gid
      owner_uid   = var.posix_user.uid
      permissions = var.permissions
    }
  }

  tags = module.label.tags
}
