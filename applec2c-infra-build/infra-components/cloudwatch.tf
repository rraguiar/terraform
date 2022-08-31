resource "aws_cloudwatch_log_group" "cw" {
  name = "/${var.application_name}/${var.environment}/"

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "/${var.application_name}/${var.environment}/"
      "service_role" = "cloudwatch"
    })
  )
}