# Create Redis Cache cluster ########################################################################
resource "aws_elasticache_replication_group" "redis" {
  automatic_failover_enabled    = false
  availability_zones            = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  replication_group_id          = "${var.environment}-${var.customer}-${var.application_name}-redis"
  replication_group_description = "${var.customer} ${var.application_name} ${var.environment} replication group"
  engine_version                = var.redis_engine_version
  node_type                     = var.redis_instance_type
  number_cache_clusters         = var.redis_cluster_size
  parameter_group_name          = var.redis_parameter_group
  port                          = 6379
  auto_minor_version_upgrade    = false
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = false
  subnet_group_name             = aws_elasticache_subnet_group.redis.name
  security_group_ids            = [aws_security_group.databases.id]
  maintenance_window            = "sun:04:00-sun:07:00"
  snapshot_window               = "00:00-03:00"
  snapshot_retention_limit      = 7
  lifecycle {
    ignore_changes = [number_cache_clusters]
  }
  depends_on = [aws_security_group.databases]
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-redis"
      "service_role" = "redis"
    })
  )
}

# Create Redis Cache subnet group ###################################################################
resource "aws_elasticache_subnet_group" "redis" {
  name        = "${var.environment}-${var.customer}-${var.application_name}-subnet"
  description = "${var.customer} ${var.application_name} ${var.environment} subnet group"
  subnet_ids  = [var.database_subnet_id[0], var.database_subnet_id[1], var.database_subnet_id[2]]
}
