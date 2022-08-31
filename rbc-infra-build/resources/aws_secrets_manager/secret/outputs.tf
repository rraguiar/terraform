output "this" {
  value = {
    secret  = aws_secretsmanager_secret.this
    version = aws_secretsmanager_secret_version.this
  }
}
