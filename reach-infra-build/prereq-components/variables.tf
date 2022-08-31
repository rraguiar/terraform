# AWS
variable "account_id" {}
variable "aws_region" {}

# ACM
variable "acm_domain_prefix" {}

# DNS
variable "r53_domain" {}

# EC2
variable "ec2_instance_type" {}

# ECS
variable "ecs_ami" {}
variable "ecs_instance_type" {}

# Autoscaling Group
variable "asg_desired_capacity" {}
variable "asg_max_size" {}
variable "asg_min_size" {}

# ECR
variable "ecr_container_service_name" {}
variable "ecr_image_tag_mutability" {}
variable "ecr_encryption_type" {}

# Redis
variable "redis_parameter_group" {}
variable "redis_instance_type" {}
variable "redis_cluster_size" {}
variable "redis_engine_version" {}

# RDS
variable "db_instance_class" {}
variable "db_instance_count" {}
variable "db_instance_engine" {}
variable "db_engine_version" {}
variable "db_monitoring_role" {}
variable "db_database_name" {}

# VPC
variable "vpc_cidr" {}
variable "az_count" {}
variable "private_cidr" {}
variable "public_cidr" {}
variable "database_cidr" {}

# Number of services
variable "api_desired_count" {}
variable "amazon_api_desired_count" {}
variable "listener_desired_count" {}

# Tags
variable "application_name" {}
variable "customer" {}
variable "deployment_tool" {}
variable "environment" {}
variable "managedby" {}
variable "owner" {}
variable "project" {}
variable "newrelic_env" {}
variable "newrelic_license" {}

