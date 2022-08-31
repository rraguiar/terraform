# AWS
account_id = "738001968068"
aws_region = "us-east-1"

# Tags
environment      = "prod"
newrelic_env     = "Prod"
newrelic_license = "c362714f3819d83aef43a8a18fbc1e07bd02NRAL"

# VPC
vpc_cidr = "10.12.32.0/20"
az_count = 3
private_cidr = {
  "0" = "10.12.32.0/23"
  "1" = "10.12.36.0/23"
  "2" = "10.12.40.0/23"
}

public_cidr = {
  "0" = "10.12.34.0/24"
  "1" = "10.12.38.0/24"
  "2" = "10.12.42.0/24"
}

database_cidr = {
  "0" = "10.12.35.0/24"
  "1" = "10.12.39.0/24"
  "2" = "10.12.43.0/24"
}

ecs_instance_type    = "t3.large"
asg_desired_capacity = 3
asg_max_size         = 5
asg_min_size         = 2
db_instance_class    = "db.r5.large"
rds_instance_count   = 2

# Redis
#instance_type      = "cache.t3.medium"
#redis_cluster_size = 1

# Number of services
api_desired_count        = 3
amazon_api_desired_count = 3
listener_desired_count   = 1