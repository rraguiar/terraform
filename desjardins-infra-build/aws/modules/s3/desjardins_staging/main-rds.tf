#
# RDS / Dump bucket
#
module "rds_dump" {
  source = "../../../resources/aws_s3/bucket"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "rds-dump"
  tags        = var.label.tags

  sse_key_arn        = var.storage_key_arn
  versioning_enabled = false
}
