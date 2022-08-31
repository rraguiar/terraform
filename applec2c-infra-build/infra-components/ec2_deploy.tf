# Deploy EC2 instance for Deploy Server - Docker Swarm Manager ######################################
resource "aws_instance" "deploy" {
  ami                         = var.ecs_ami
  availability_zone           = data.aws_availability_zones.available.names[1]
  instance_type               = var.ec2_instance_type
  key_name                    = "${var.environment}-${var.customer}-${var.application_name}-deploy-keypair"
  subnet_id                   = var.public_subnet_id[1]
  vpc_security_group_ids      = [aws_security_group.deploy.id]
  user_data                   = templatefile("../templates/${var.environment}-infra-apple-deploy-user-data.sh.tpl", {})
  iam_instance_profile        = aws_iam_instance_profile.deploy.name
  associate_public_ip_address = true
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 80
    delete_on_termination = true
    encrypted             = true
  }
  depends_on = [aws_iam_role.deploy]
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-deploy"
      "service_role" = "deploy"
    })
  )
}

# Assign Elastic IP address #########################################################################
resource "aws_eip" "deploy" {
  instance = aws_instance.deploy.id
  vpc      = true
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-deploy-eip"
      "service_role" = "eip"
    })
  )
}