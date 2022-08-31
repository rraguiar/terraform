module "vpc" {
  source = "../../../resources/aws_network/vpc"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  availability_zones  = var.vpc_availability_zones
  cidr_block          = var.vpc_cidr_block
  cidr_subnet_newbits = var.vpc_cidr_subnet_newbits
  cidr_subnet_steps   = var.vpc_cidr_subnet_steps
  elastic_ips         = var.vpc_elastic_ips
}
