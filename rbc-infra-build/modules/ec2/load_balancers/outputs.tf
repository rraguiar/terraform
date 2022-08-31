output "lb" {
  value = module.lb_instance
}

output "lb_listeners" {
  value = module.lb_target.listeners
}

output "lb_targets" {
  value = module.lb_target.target_groups
}
