module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

resource "aws_eip" "this" {
  for_each = var.availability_zones

  tags = merge(module.label.tags, {
    Name = format("%s-%s", module.label.id, substr(each.value, -1, 1))
  })

  vpc = true
}
