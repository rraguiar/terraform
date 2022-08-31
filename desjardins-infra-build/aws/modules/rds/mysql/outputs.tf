output "mysql" {
  value = module.mysql
}

output "extras" {
  value = {
    db_name = var.db_name,
    db_port = var.db_port,
  }
}
