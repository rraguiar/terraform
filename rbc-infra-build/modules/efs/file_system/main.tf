module "file_system" {
  source = "../../../resources/aws_efs/file_system"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  security_group_rules = {
    nfs_a_private = {
      type       = "ingress"
      from_port  = "2049"
      to_port    = "2049"
      cidr_block = var.subnet_cidrs.private[0]
    },
    nfs_b_private = {
      type       = "ingress"
      from_port  = "2049"
      to_port    = "2049"
      cidr_block = var.subnet_cidrs.private[1]
    },
    nfs_d_private = {
      type       = "ingress"
      from_port  = "2049"
      to_port    = "2049"
      cidr_block = var.subnet_cidrs.private[2]
    },
    nfs_a_public = {
      type       = "ingress"
      from_port  = "2049"
      to_port    = "2049"
      cidr_block = var.subnet_cidrs.public[0]
    },
    nfs_b_public = {
      type       = "ingress"
      from_port  = "2049"
      to_port    = "2049"
      cidr_block = var.subnet_cidrs.public[1]
    },
    nfs_d_public = {
      type       = "ingress"
      from_port  = "2049"
      to_port    = "2049"
      cidr_block = var.subnet_cidrs.public[2]
    },
  }

  kms_key_id = var.storage_key_arn
  subnet_ids = var.subnet_ids.private
  vpc_id     = var.vpc_id
}
