output "id" {
  value       = aws_ecr_repository.this.*.registry_id
  description = "Registry ID"
}

output "name" {
  value       = aws_ecr_repository.this.*.name
  description = "Registry name"
}

output "url" {
  value       = aws_ecr_repository.this.*.repository_url
  description = "Registry URL"
}
