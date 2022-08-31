# Define the common tags for all resources
locals {
  common_tags = {
    application_name = var.application_name
    customer         = var.customer
    deployment_tool  = "terraform"
    environment      = var.environment
    managedby        = "devsecops@engage.com"
    project          = var.project
    owner            = var.owner
    managedby        = var.managedby
  }
}
