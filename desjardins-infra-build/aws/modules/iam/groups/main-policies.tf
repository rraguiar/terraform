#
# Default person privileges
#
module "aws_policy_person" {
  source = "../../../resources/aws_policy/person_privileges"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "person-privileges"

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

  path = "/"

  require_mfa = true
  role_arns = [
    var.develop_role_arns.developer,
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

  path = "/"

  require_mfa = true
  role_arns = [
    var.develop_role_arns.read_only,
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

  path = "/"

  require_mfa = true
  role_arns = [
    var.develop_role_arns.superuser,
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

  path = "/"

  require_mfa = true
  role_arns = [
    var.develop_role_arns.terraform,
  ]
}
