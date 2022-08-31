module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

resource "aws_nat_gateway" "this" {
  for_each = var.subnet_map

  allocation_id = var.elastic_ips[each.key].id
  subnet_id     = each.value

  tags = merge(module.label.tags, {
    Name = format("%s-%s", module.label.id, substr(each.key, -1, 1))
  })
}
