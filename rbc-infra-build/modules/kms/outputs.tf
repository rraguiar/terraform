output "secrets_key" {
  description = "The KMS secrets key"
  value = {
    arn  = module.secrets_key.arn
    id   = module.secrets_key.id
    name = module.secrets_key.name
  }
}

output "storage_key" {
  description = "The KMS storage key"
  value = {
    arn  = module.storage_key.arn
    id   = module.storage_key.id
    name = module.storage_key.name
  }
}
