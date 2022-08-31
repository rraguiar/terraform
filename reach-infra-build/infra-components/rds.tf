# Database Subnet Group #############################################################################
resource "aws_db_subnet_group" "db_subnet" {
  name        = "${var.environment}-${var.customer}-${var.application_name}-db-subnet"
  description = "DB subnet group for ${var.customer} ${var.application_name} ${var.environment}"
  subnet_ids  = [var.database_subnet_id[0], var.database_subnet_id[1], var.database_subnet_id[2]]
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-db-subnet"
      "service_role" = "subnetgroup"
    })
  )
}

# Create Database Instances #########################################################################
resource "aws_db_instance" "db_instance" {
  count                           = var.db_instance_count
  availability_zone               = data.aws_availability_zones.available.names[0]
  identifier                      = "${var.environment}-${var.customer}-${var.application_name}-${var.db_instance_engine}-instance-${count.index + 1}"
  db_subnet_group_name            = aws_db_subnet_group.db_subnet.id
  instance_class                  = var.db_instance_class
  username                        = "admin"
  password                        = data.aws_secretsmanager_secret_version.db_admin_password.secret_string
  publicly_accessible             = false
  monitoring_role_arn             = var.db_monitoring_role
  monitoring_interval             = 5
  auto_minor_version_upgrade      = false
  copy_tags_to_snapshot           = true
  allocated_storage               = 25
  max_allocated_storage           = 50
  multi_az                        = false
  engine                          = var.db_instance_engine
  skip_final_snapshot             = true
  storage_encrypted               = true
  backup_retention_period         = 7
  backup_window                   = "00:00-02:00"
  deletion_protection             = false
  maintenance_window              = "wed:03:00-wed:05:00"
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-${var.db_instance_engine}-instance-${count.index + 1}"
      "service_role" = "rds"
    })
  )
}

