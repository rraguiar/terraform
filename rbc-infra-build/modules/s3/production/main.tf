#
# S3 / Main Bucket
#
module "main" {
  source = "../../../resources/aws_s3/bucket"

  namespace   = var.label.namespace
  stage       = var.label.stage
  environment = var.label.environment
  name        = "bucket"
  tags        = var.label.tags

  acl                = "private"
  sse_key_arn        = var.storage_key_arn
  versioning_enabled = false
}
