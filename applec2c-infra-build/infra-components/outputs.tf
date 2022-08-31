# S3 Details
output "s3_bucket_name" {
  value = concat(aws_s3_bucket.bucket.*.arn, [""], )[0]
}

# Security Group
output "alb_sg_name" {
  description = "The name of the ALB security group"
  value       = concat(aws_security_group.alb.*.name, [""], )[0]
}
output "alb_sg_id" {
  description = "The ID of the Load Balancer security group"
  value       = concat(aws_security_group.alb.*.id, [""], )[0]
}

output "databases_sg_name" {
  description = "The name of the DBs security group"
  value       = concat(aws_security_group.databases.*.name, [""], )[0]
}
output "databases_sg_id" {
  description = "The ID of the DBs security group"
  value       = concat(aws_security_group.databases.*.id, [""], )[0]
}

output "deploy_sg_name" {
  description = "The name of the Deploy security group"
  value       = concat(aws_security_group.deploy.*.name, [""], )[0]
}
output "deploy_sg_id" {
  description = "The ID of the Deploy security group"
  value       = concat(aws_security_group.deploy.*.id, [""], )[0]
}

output "node_private_sg_name" {
  description = "The name of the Node security group"
  value       = concat(aws_security_group.node.*.name, [""], )[0]
}
output "node_private_sg_id" {
  description = "The ID of the Node security group"
  value       = concat(aws_security_group.node.*.id, [""], )[0]
}

# IAM
output "task_execution_iam_role_name" {
  description = "Name of Task Execution role"
  value       = element(concat(aws_iam_role.ecs.*.name, [""]), 0)
}
output "task_execution_iam_role_arn" {
  description = "ARN of Task Execution role"
  value       = element(concat(aws_iam_role.ecs.*.arn, [""]), 0)
}
output "task_execution_iam_policy_arn" {
  description = "ARN of Task Execution policy"
  value       = element(concat(aws_iam_policy.ecs.*.arn, [""]), 0)
}
output "task_execution_iam_policy_name" {
  description = "Name of Task Execution policy"
  value       = element(concat(aws_iam_policy.ecs.*.name, [""]), 0)
}

output "deploy_iam_role_name" {
  description = "Name of Deploy role"
  value       = element(concat(aws_iam_role.deploy.*.name, [""]), 0)
}
output "deploy_iam_role_arn" {
  description = "ARN of Deploy role"
  value       = element(concat(aws_iam_role.deploy.*.arn, [""]), 0)
}
output "deploy_iam_policy_name" {
  description = "Name of Deploy policy"
  value       = element(concat(aws_iam_policy.deploy.*.name, [""]), 0)
}
output "deploy_iam_policy_arn" {
  description = "ARN of Deploy policy"
  value       = element(concat(aws_iam_policy.deploy.*.arn, [""]), 0)
}

# EC2
output "deploy_server_id" {
  description = "List of Deploy server(s) ID(s)"
  value       = element(concat(aws_instance.deploy.*.id, [""]), 0)
}
output "deploy_server_ip" {
  description = "List of Deploy server(s) IP(s)"
  value       = element(concat(aws_eip.deploy.*.public_dns, [""]), 0)
}

# Load Balancers
output "load_balancer_name" {
  description = "Application Load Balancer Name"
  value       = aws_lb.single.name
}
output "load_balancer_dns_name" {
  description = "Application Load Balancer DNS"
  value       = aws_lb.single.dns_name
}

# Redis
#output "redis_instance_id" {
#  description = "List of Redis Cache"
#  value       = element(concat(aws_elasticache_replication_group.redis.*.id, [""]), 0)
#}
#output "redis_instance_primary_endpoint_address" {
#  description = "List of Redis Cache"
#  value       = element(concat(aws_elasticache_replication_group.redis.*.primary_endpoint_address, [""]), 0)
#}

# RDS
output "db_instance_id" {
  description = "List of MariaDB instance name"
  value       = element(concat(aws_db_instance.db_instance.*.id, [""]), 0)
}
output "db_primary_endpoint" {
  description = "List of DB primary endpoint"
  value       = element(concat(aws_db_instance.db_instance.*.endpoint, [""]), 0)
}

# Route53
output "dns_admin" {
  description = "Admin URL"
  value       = aws_route53_record.admin.name
}

output "dns_api" {
  description = "API URL"
  value       = aws_route53_record.api.name
}
