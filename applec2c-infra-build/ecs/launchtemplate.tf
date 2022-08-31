resource "aws_launch_template" "ecs_node" {
  name_prefix            = "${var.environment}-${var.customer}-${var.application_name}-ecs-cluster"
  image_id               = var.ecs_ami
  instance_type          = var.ecs_instance_type
  key_name               = "${var.environment}-${var.customer}-${var.application_name}-ecs-node-keypair"
  vpc_security_group_ids = [var.ecs_security_group]

  credit_specification {
    cpu_credits = "standard"
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_node.name
  }

  user_data = base64encode(templatefile("templates/user-data.tmpl", { cluster_name = aws_ecs_cluster.ecs.name }))

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-ecs-cluster"
      "service_role" = "alt"
    })
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      tomap({
        "Name" = "${var.environment}-${var.customer}-${var.application_name}-ecs-node"
        "service_role" = "ec2"
      })
    )
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 80
      volume_type = "gp2"
      kms_key_id  = data.aws_kms_alias.ebs.arn
      encrypted   = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}