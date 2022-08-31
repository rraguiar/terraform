module "redis" {
  source = "../../..//resources/aws_elasticache/redis"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name
  tags        = var.label.tags
  label_order = ["stage", "namespace", "environment", "name"]

  availability_zones   = var.availability_zones
  security_group_rules = var.security_group_rules
  subnets              = var.subnet_ids
  vpc_id               = var.vpc_id
  zone_id              = var.route53_zone_id

  engine_version             = var.engine_version
  family                     = var.family
  cluster_size               = var.cluster_size
  instance_type              = var.instance_type
  apply_immediately          = var.apply_immediately
  automatic_failover_enabled = var.automatic_failover_enabled

  at_rest_encryption_enabled = var.storage_key_arn == null ? false : true
  transit_encryption_enabled = var.transit_encryption_enabled
  kms_key_id                 = var.storage_key_arn
}
