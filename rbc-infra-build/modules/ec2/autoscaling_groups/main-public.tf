#
# ASG / Public
#
module "public" {
  source = "../../../resources/aws_ec2/autoscaling_group"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = format("%s-public", var.label.name)
  tags        = var.label.tags

  ami_name          = var.ami_name
  ami_instance_type = var.ami_instance_type
  ami_owners        = var.ami_owners

  asg_protect_from_scale_in = false
  asg_min_size              = var.target_capacity.public.min
  asg_max_size              = var.target_capacity.public.max

  iam_instance_role_name = module.instance_role.name

  security_group_rules = var.security_group_rules_public

  user_data = base64encode(data.template_file.userdata.rendered)

  vpc_id = var.vpc_id

  # this is what makes it public
  vpc_zone_identifier = var.subnet_ids.public
}
