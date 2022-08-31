# AWS
account_id = "738001968068"
aws_region = "ca-central-1"

# ACM
acm_domain_prefix = "*"

# APM
newrelic_env     = "uat"
newrelic_license = "c362714f3819d83aef43a8a18fbc1e07bd02NRAL"

# Autoscaling Group
asg_desired_capacity = 1
asg_max_size         = 1
asg_min_size         = 1

# DNS
r53_domain = "applebyengage.com"

# EC2
ec2_instance_type = "t3.medium"

# ECR
ecr_container_service_name = ""
ecr_image_tag_mutability   = ""
ecr_encryption_type        = ""

# ECS
ecs_ami               = "ami-02a7491da9a193d2a"
ecs_instance_type     = "t3.medium"
ecs_container_version = "v0.0.12-14"

# KMS
kms_key_id = "alias/aws/ebs"

# Networking (VPC)
# Only for Staging environment because Staging is deployed in a shared VPC
vpc_id = "vpc-09a8ee7907ea3e0de"
private_subnet_id = {
  "0" = "subnet-08e8c5b8bf7631803"
  "1" = "subnet-0e6526576f4ade482"
}
public_subnet_id = {
  "0" = "subnet-01344f2efde3c0ba6"
  "1" = "subnet-0681b1e81ea375787"
}
database_subnet_id = {
  "0" = "subnet-0667a9c0957fb6e23"
  "1" = "subnet-09f9e47db268a04fc"
}

# Redis
#redis_instance_type   = "cache.t3.small"
#redis_cluster_size    = 1
#redis_engine_version  = "5.0.6"
#redis_parameter_group = "default.redis5.0"

# RDS
db_instance_count  = 1
db_instance_class  = "db.t3.small"
db_instance_engine = "mariadb"
db_engine_version  = "10.4.13"
db_monitoring_role = "arn:aws:iam::738001968068:role/rds-monitoring-role"
db_database_name   = "apple"

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
  "0" = "10.0.56.0/21"
  "1" = "10.0.56.0/21"
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
  "2" = "10.0.56.0/21"
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
  "0" = "10.0.56.0/21"
}

# Tags
application_name = "apple"
customer         = "infra"
deployment_tool  = "terraform"
environment      = "uat"
managedby        = "devsecops@engagepeople.com"
project          = "apple"
owner            = "ewwong@engagepeople.com"






