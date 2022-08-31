module "access_point" {
  source = "../../../resources/aws_efs/access_point"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  file_system_id = var.file_system_id
  posix_user     = var.posix_user
  permissions    = var.permissions
  root_directory = var.root_directory
}
