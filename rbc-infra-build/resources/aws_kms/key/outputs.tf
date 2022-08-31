output "arn" {
  description = "The ARN of the resource"
  value       = aws_kms_key.this.arn
}

output "id" {
  description = "The ID of the resource"
  value       = aws_kms_key.this.key_id
}

output "name" {
  description = "The name of the resource"
  value       = aws_kms_alias.this.name
}

output "label" {
  description = "The label id"
  value       = module.label.id
}
