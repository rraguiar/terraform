module "elastic_ips" {
  source = "../../../resources/aws_ec2/elastic_ips"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags

  # cheat with an intermediate map(string) where k/v are the same
  availability_zones = zipmap(
    var.vpc_availability_zones,
    var.vpc_availability_zones
  )
}
