data "template_file" "userdata" {
  template = file("${path.module}/userdata.sh")
  vars = {
    stage       = var.label.stage
    namespace   = var.label.namespace
    environment = var.label.environment
    name        = var.label.name
  }
}
