#
# Groups
#
module "aws_group_developer" {
  source = "../../../resources/aws_iam/group"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "developer"

  path = "/"

  policy_arns = [
    module.aws_policy_person.arn,
    module.aws_policy_assume_developer.arn,
  ]
}

module "aws_group_readonly" {
  source = "../../../resources/aws_iam/group"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "readonly"

  path = "/"

  policy_arns = [
    module.aws_policy_person.arn,
    module.aws_policy_assume_readonly.arn,
  ]
}

module "aws_group_superuser" {
  source = "../../../resources/aws_iam/group"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "superuser"

  path = "/"

  policy_arns = [
    module.aws_policy_person.arn,
    module.aws_policy_assume_superuser.arn,
    module.aws_policy_assume_terraform.arn,
  ]
}
