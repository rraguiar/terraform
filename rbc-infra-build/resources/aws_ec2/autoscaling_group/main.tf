module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

locals {
  description = var.lt_description == null ? module.label.id : var.lt_description
  ami_id      = var.ami_id == null ? data.aws_ami.this.id : var.ami_id

  security_group_ids = concat(
    [module.security_group.id],
    var.security_group_ids,
  )
}

#
# AMI lookup
#
data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = var.ami_owners
}

#
# IAM instance profile
#
resource "aws_iam_instance_profile" "this" {
  name = module.label.id
  role = var.iam_instance_role_name
}

#
# Security group
#
module "security_group" {
  source = "../security_group"

  namespace   = module.label.namespace
  stage       = module.label.stage
  environment = module.label.environment
  name        = module.label.name
  tags        = module.label.tags

  description = module.label.id
  vpc_id      = var.vpc_id

  rules = var.security_group_rules

  trust_targets = merge({
    default = { type = "egress", cidr_block = "0.0.0.0/0" },
    self    = { type = "ingress", self = true }
  }, var.security_group_targets)
}

#
# Launch template
#
resource "aws_launch_template" "this" {
  name        = module.label.id
  tags        = module.label.tags
  description = local.description

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    iterator = device

    content {
      device_name = device.value.device_name

      ebs {
        volume_size           = lookup(device.value, "volume_size", null)
        volume_type           = lookup(device.value, "volume_type", null)
        delete_on_termination = lookup(device.value, "delete_on_termination", true)
      }
    }
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  ebs_optimized = var.ebs_optimized

  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
  }

  image_id      = local.ami_id
  instance_type = var.ami_instance_type
  key_name      = var.key_name

  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  dynamic "network_interfaces" {
    for_each = var.network_interfaces
    iterator = inf

    content {
      delete_on_termination = lookup(inf, "delete_on_termination", true)
      description           = local.description
      device_index          = lookup(inf.value, "device_index", null)
      network_interface_id  = lookup(inf.value, "network_interface_id", null)
      private_ip_address    = lookup(inf.value, "private_ip_address", null)
      ipv4_address_count    = lookup(inf.value, "ipv4_address_count", null)
      security_groups = compact(concat(
        local.security_group_ids,
        split(",", lookup(inf.value, "security_groups", ""))
      ))
      subnet_id = lookup(inf.value, "subnet_id", null)
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = module.label.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = module.label.tags
  }

  user_data = var.user_data
}

#
# Autoscaling Group
#
resource "aws_autoscaling_group" "this" {
  name = module.label.id

  default_cooldown      = var.asg_default_cooldown
  desired_capacity      = var.asg_min_size
  min_size              = var.asg_min_size
  max_size              = var.asg_max_size
  protect_from_scale_in = var.asg_protect_from_scale_in

  enabled_metrics = var.enabled_metrics

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type
  max_instance_lifetime     = var.asg_max_instance_lifetime
  vpc_zone_identifier       = toset(var.vpc_zone_identifier)

  suspended_processes       = []
  wait_for_capacity_timeout = 0

  lifecycle {
    ignore_changes = [
      desired_capacity,
      tag,
    ]
  }
}
