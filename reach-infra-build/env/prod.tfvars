# AWS
account_id = "738001968068"
aws_region = "ca-central-1"

# ACM
acm_domain_prefix = "*"

# Tags
environment      = "prod"
newrelic_env     = "Prod"
newrelic_license = "c362714f3819d83aef43a8a18fbc1e07bd02NRAL"

# VPC
vpc_id = "vpc-03168075d27d2c247"
vpc_cidr = "10.12.32.0/20"
az_count = 3
availability_zones = 3
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

# Subnets
public_subnet_id = {
  "0" = "subnet-0533b4a68b0c7e2cf"
  "1" = "subnet-0226ff5480759978d"
  "2" = "subnet-002ce562e557dd07c"
}

private_subnet_id = {
  "0" = "subnet-0919b4750d7465755"
  "1" = "subnet-06b07bf6b722f3b46"
  "2" = "subnet-0b9743eea544e6702"
}

database_subnet_id = {
  "0" = "subnet-0b1f1a80499d2e84a"
  "1" = "subnet-05c0c05fc09dcd09a"
  "2" = "subnet-0424a0d6ac35ac901"
}
# Autoscaling Group
asg_desired_capacity = 3
asg_max_size         = 5
asg_min_size         = 2

# DNS
r53_domain = "reachbyengage.com"

# KMS
kms_key_id = "alias/aws/ebs"

# EC2
ec2_instance_type    =  "t3.large"

# ECR
ecr_container_service_name = ""
ecr_image_tag_mutability   = "MUTABLE"
ecr_encryption_type        = "AES256"

# ECS
ecs_ami               = "ami-02a7491da9a193d2a"
ecs_instance_type     = "t3.large"
ecs_container_version = "1.54.0"
ecs_security_group   = "sg-0ac913f67383d3093"

# Redis
redis_instance_type  = "cache.t3.medium"
redis_cluster_size   = 3
redis_engine_version  = "5.0.6"
redis_parameter_group = "default.redis5.0"

# RDS
db_instance_class    = "db.r5.large"
#rds_instance_count   = 2
db_instance_count   = 2
db_instance_engine = "mariadb"
db_engine_version  = "10.4.13"
db_monitoring_role = "arn:aws:iam::738001968068:role/rds-monitoring-role"
db_database_name   = "reach"

# Security Group
alb_ingress_description = {
  "0" = "Allow internet access"
  "1" = "Allow internet access"
}
alb_ingress_protocol = {
  "0" = "TCP"
  "1" = "TCP"
}
alb_ingress_port = {
  "0" = "80"
  "1" = "443"
}
alb_ingress_ip = {
  "0" = "0.0.0.0/0"
  "1" = "0.0.0.0/0"
}
databases_ingress_description = {
  "0" = "Allow VPC CIDR"
  "1" = "Allow VPC CIDR"
}
databases_ingress_protocol = {
  "0" = "TCP"
  "1" = "TCP"
}
databases_ingress_ip = {
  "0" = "10.12.32.0/20"
}
databases_ingress_port = {
  "0" = "6379"
  "1" = "3306"
}
deploy_ingress_description = {
  "0" = "Allow Office CIDR"
  "1" = "Allow Jumpbox"
  "2" = "Allow VPC CIDR"
}
deploy_ingress_from_port = {
  "0" = "22"
  "1" = "22"
  "2" = "0"
}
deploy_ingress_to_port = {
  "0" = "22"
  "1" = "22"
  "2" = "65535"
}
deploy_ingress_protocol = {
  "0" = "TCP"
  "1" = "TCP"
  "2" = "-1"
}
deploy_ingress_ip = {
  "0" = "207.35.68.82/32"
  "1" = "52.44.76.12/32"
  "2" = "10.12.32.0/20"
}
node_ingress_description = {
  "0" = "Allow VPC CIDR"
}
node_ingress_from_port = {
  "0" = "0"
}
node_ingress_to_port = {
  "0" = "65535"
}
node_ingress_protocol = {
  "0" = "-1"
}
node_ingress_ip = {
  "0" = "10.12.32.0/20"
}

# Number of services
api_desired_count        = 3
amazon_api_desired_count = 3
listener_desired_count   = 1

# Tags
application_name = "reach"
customer         = "infra"
deployment_tool  = "terraform"
#environment      = "prod"
managedby        = "devsecops@engagepeople.com"
project          = "reach"
owner            = "ewwong@engagepeople.com"