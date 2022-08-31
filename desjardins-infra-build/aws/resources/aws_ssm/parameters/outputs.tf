output "arns" {
  description = "The parameter ARNs"
  value = merge(
    { for k, o in aws_ssm_parameter.secret : k => o.arn },
    { for k, o in aws_ssm_parameter.parameter : k => o.arn },
  )
}

output "names" {
  description = "The parameter names"
  value = merge(
    { for k, o in aws_ssm_parameter.secret : k => format("/%s/%s", module.label.stage, k) },
    { for k, o in aws_ssm_parameter.parameter : k => format("/%s/%s", module.label.stage, k) },
  )
}
