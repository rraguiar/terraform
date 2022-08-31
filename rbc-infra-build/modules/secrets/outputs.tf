output "arns" {
  value = { for k, v in module.secrets : trimprefix(k, "/") => v.this.secret.arn }
}

output "names" {
  value = { for k, v in module.secrets : trimprefix(k, "/") => v.this.secret.name }
}

//output "secrets" {
//  value = module.secrets
//}
