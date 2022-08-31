# AWS Account information
variable "account_id" {}

# Autoscaling Group
variable "asg_desired_capacity" {}
variable "asg_max_size" {}
variable "asg_min_size" {}

# DNS (Route 53)
variable "r53_domain" {}

# ECS
variable "ecs_ami" {}
variable "ecs_instance_type" {}
variable "ecs_container_version" {}
variable "ecs_security_group" {}

# KMS (Encryption Key)
variable "kms_key_id" {}

# Networking
# Only for Staging environment because Staging is deployed in a shared VPC
variable "vpc_id" {}
variable "private_subnet_id" {}
variable "public_subnet_id" {}
variable "database_subnet_id" {}

# New Relic
variable "newrelic_env" {}
variable "newrelic_license" {}

# Tags
variable "application_name" {}
variable "customer" {}
variable "deployment_tool" {}
variable "environment" {}
variable "managedby" {}
variable "project" {}
variable "owner" {}

#RDS
variable "db_database_name" {}
variable "db_instance_engine" {}

#ECS Node
variable "node_ingress_ip" {}

# Security
# Load Balancer SG
variable "alb_ingress_ip" {}


