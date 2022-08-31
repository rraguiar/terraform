module "label" {
  source = "../../../resources/aws_data/label"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = var.label.name

  label_order = ["namespace", "stage", "name"]
}

#
# External Users
#
module "aws_user_laurent_vincentelli" {
  source = "../../../resources/aws_iam/user_person"

  name = "laurent.vincentelli@gsquad.io"
  tags = module.label.tags

  enabled = true
  groups = [
    var.group_names.superuser,
  ]
}
