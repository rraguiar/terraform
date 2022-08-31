# AWS
variable "account_id" {}
variable "aws_region" {}

# VPC
variable "az_count" {}
variable "availability_zones" {}
variable "vpc_cidr" {}
variable "private_cidr" {}
variable "public_cidr" {}
variable "database_cidr" {}

# ACM
variable "acm_domain_prefix" {}

# EC2
variable "ec2_instance_type" {}

# KMS
variable "kms_key_id" {}

# Tags
variable "environment" {}
variable "newrelic_env" {}
variable "newrelic_license" {}
variable "application_name" {}
variable "customer" {}
variable "owner" {}
variable "project" {}
variable "managedby" {}

# Networking
variable "vpc_id" {}
variable "private_subnet_id" {}
variable "public_subnet_id" {}
variable "database_subnet_id" {}
variable "r53_domain" {}

# Autoscaling group
variable "asg_desired_capacity" {}
variable "asg_max_size" {}
variable "asg_min_size" {}

# Redis
variable "redis_parameter_group" {}
variable "redis_instance_type" {}
variable "redis_cluster_size" {}
variable "redis_engine_version" {}

# RDS
variable "db_instance_class" {}
variable "db_instance_count" {}
variable "db_instance_engine" {}
variable "db_monitoring_role" {}
variable "db_database_name" {}
variable "db_engine_version" {}

# ECS
variable "ecs_ami" {}
variable "ecs_instance_type" {}

# ECR
variable "ecr_container_service_name" {}
variable "ecr_image_tag_mutability" {}
variable "ecr_encryption_type" {}

# Security
# Load Balancer SG
variable "alb_ingress_description" {}
variable "alb_ingress_protocol" {}
variable "alb_ingress_port" {}
variable "alb_ingress_ip" {}

# Database SG
variable "databases_ingress_description" {}
variable "databases_ingress_protocol" {}
variable "databases_ingress_ip" {}
variable "databases_ingress_port" {}

# EC2 SG
variable "deploy_ingress_description" {}
variable "deploy_ingress_from_port" {}
variable "deploy_ingress_to_port" {}
variable "deploy_ingress_protocol" {}
variable "deploy_ingress_ip" {}

# ECS Node
variable "node_ingress_description" {}
variable "node_ingress_from_port" {}
variable "node_ingress_to_port" {}
variable "node_ingress_protocol" {}
variable "node_ingress_ip" {}

# Number of services
variable "api_desired_count" {}
variable "amazon_api_desired_count" {}
variable "listener_desired_count" {}

# Tags
variable "deployment_tool" {}
#variable "api_desired_count" {}
#variable "api_desired_count" {}
