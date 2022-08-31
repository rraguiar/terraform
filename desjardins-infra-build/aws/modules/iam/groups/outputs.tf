#
# Groups
#
output "group_developer" {
  description = "Superuser group details"
  value       = module.aws_group_developer
}

output "group_readonly" {
  description = "Superuser group details"
  value       = module.aws_group_readonly
}

output "group_superuser" {
  description = "Superuser group details"
  value       = module.aws_group_superuser
}

#
# Policies
#
output "policy_assume_developer" {
  description = "Policy which allows role assumption to Superuser"
  value       = module.aws_policy_assume_developer
}

output "policy_assume_readonly" {
  description = "Policy which allows role assumption to Superuser"
  value       = module.aws_policy_assume_readonly
}

output "policy_assume_superuser" {
  description = "Policy which allows role assumption to Superuser"
  value       = module.aws_policy_assume_superuser
}

output "policy_person" {
  description = "Default permissions for a manafont user"
  value       = module.aws_policy_person
}
