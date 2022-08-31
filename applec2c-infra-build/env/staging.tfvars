# AWS
account_id = "738001968068"
aws_region = "ca-central-1"

# ACM
acm_domain_prefix = "*"

# APM
newrelic_env     = "staging"
newrelic_license = "c362714f3819d83aef43a8a18fbc1e07bd02NRAL"

# Autoscaling Group
asg_desired_capacity = 1
asg_max_size         = 1
asg_min_size         = 1

# DNS
r53_domain = "reachbyengage.com"

# EC2
ec2_instance_type = "t2.small"

# ECR
ecr_container_service_name = ""
ecr_image_tag_mutability   = "MUTABLE"
ecr_encryption_type        = "AES256"

# ECS
ecs_ami               = "ami-0895902bd5fd037cc"
ecs_instance_type     = "t2.small"
ecs_container_version = "v0.0.169-197"
#ecs_security_group    = "sg-0c2513f672c0360e2"
ecs_security_group    = "sg-00e6a93cb6bd81c9d"

# KMS
kms_key_id = "alias/aws/ebs"

# Networking (VPC)
# Only for Staging environment because Staging is deployed in a shared VPC
vpc_id = "vpc-0cb899076ca6e31b4"
private_subnet_id = {
  "0" = "subnet-05da2b68183b3fbf0"
  "1" = "subnet-023f4f576708f16d7"
}
public_subnet_id = {
  "0" = "subnet-00f1ae5b5839493d7"
  "1" = "subnet-0b68d996c96ca786d"
}
database_subnet_id = {
  "0" = "subnet-05da2b68183b3fbf0"
  "1" = "subnet-023f4f576708f16d7"
}
/*
# Redis
redis_instance_type   = "cache.t3.small"
redis_cluster_size    = 1
redis_engine_version  = "5.0.6"
redis_parameter_group = "default.redis5.0"
*/

# RDS
db_instance_count  = 1
db_instance_class  = "db.t3.small"
db_instance_engine = "mysql"
db_engine_version  = "8.0.28"
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
  "0" = "172.18.0.0/20"
  "1" = "172.18.0.0/20"
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
  "2" = "172.18.0.0/20"
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
  "0" = "172.18.0.0/20"
}

# Tags
application_name = "apple"
customer         = "infra"
deployment_tool  = "terraform"
environment      = "staging"
managedby        = "devsecops@engagepeople.com"
project          = "apple"
owner            = "spotla@engagepeople.com"






