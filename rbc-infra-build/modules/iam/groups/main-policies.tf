#
# Default person privileges
#
module "aws_policy_person" {
  source = "../../../resources/aws_policy/person_privileges"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "person-privileges"
  tags        = var.label.tags

  path = "/"
}

#
# Developer Role Policy
#
module "aws_policy_assume_developer" {
  source = "../../../resources/aws_policy/assume_roles"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "assume-developer"
  tags        = var.label.tags

  path = "/"

  require_mfa = true
  role_arns = [
    var.role_arns.developer,
  ]
}

#
# Read Only Role Policy
#
module "aws_policy_assume_readonly" {
  source = "../../../resources/aws_policy/assume_roles"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "assume-readonly"
  tags        = var.label.tags

  path = "/"

  require_mfa = true
  role_arns = [
    var.role_arns.read_only,
  ]
}

#
# Superuser Role Policy
#
module "aws_policy_assume_superuser" {
  source = "../../../resources/aws_policy/assume_roles"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "assume-superuser"
  tags        = var.label.tags

  path = "/"

  require_mfa = true
  role_arns = [
    var.role_arns.superuser,
  ]
}

#
# Terraform Role Policies
#
module "aws_policy_assume_terraform" {
  source = "../../../resources/aws_policy/assume_roles"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "assume-terraform"
  tags        = var.label.tags

  path = "/"

  require_mfa = true
  role_arns = [
    var.role_arns.terraform,
  ]
}
