output "asg" {
  value = {
    instance_role = module.instance_role,
    private       = module.private,
    public        = module.public,
  }
}
