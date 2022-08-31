#
# AWS Arn module
#
# This is a simple helper module designed to generate arns from path components
#

locals {
  path = join(var.path_delimiter, var.path)
  arn  = join(":", ["arn", var.partition, var.service, var.region, var.account, local.path])
}
