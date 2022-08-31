output "aurora" {
  value = {
    arn                = module.aurora_cluster.arn
    cluster_identifier = module.aurora_cluster.cluster_identifier
    security_groups    = module.aurora_cluster.cluster_security_groups
    endpoint           = module.aurora_cluster.endpoint
    reader_endpoint    = module.aurora_cluster.reader_endpoint
  }
}
