# Secrets
output "aws_secretsmanager_secret_application_key" {
  description = "Application Key"
  value       = element(concat(aws_secretsmanager_secret.application_key.*.id, [""]), 0)
}

output "aws_secretsmanager_secret_db_name" {
  description = "Database Name"
  value       = element(concat(aws_secretsmanager_secret.db_name.*.id, [""]), 0)
}

output "aws_secretsmanager_secret_db_host" {
  description = "RDS Database Endpoint"
  value       = element(concat(aws_secretsmanager_secret.db_host.*.id, [""]), 0)
}

output "aws_secretsmanager_secret_db_admin_password" {
  description = "DB Admin Password"
  value       = element(concat(aws_secretsmanager_secret.db_admin_password.*.id, [""]), 0)
}

output "aws_secretsmanager_secret_db_user_password" {
  description = "DB User Password"
  value       = element(concat(aws_secretsmanager_secret.db_user_password.*.id, [""]), 0)
}

output "aws_secretsmanager_secret_db_username" {
  description = "DB Username"
  value       = element(concat(aws_secretsmanager_secret.db_username.*.id, [""]), 0)
}

output "aws_secretsmanager_secret_redis_host" {
  description = "Redis Endpoint"
  value       = element(concat(aws_secretsmanager_secret.redis_host.*.id, [""]), 0)
}

output "aws_secretsmanager_secret_deploy_keypair" {
  description = "EC2 Deploy Server Keypair"
  value       = element(concat(aws_secretsmanager_secret.deploy_keypair.*.id, [""]), 0)
}

output "aws_secretsmanager_secret_node_keypair" {
  description = "EC2 Node Server Keypair"
  value       = element(concat(aws_secretsmanager_secret.node_keypair.*.id, [""]), 0)
}