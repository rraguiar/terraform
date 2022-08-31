output "arns" {
  description = "Map of assumeable role arns"
  value = {
    developer = module.developer_role.arn
    read_only = module.readonly_role.arn
    superuser = module.superuser_role.arn
    terraform = module.terraform_role.arn
  }
}

output "names" {
  description = "Map of assumeable role names"
  value = {
    developer = module.developer_role.name
    read_only = module.readonly_role.name
    superuser = module.superuser_role.name
    terraform = module.terraform_role.name
  }
}
