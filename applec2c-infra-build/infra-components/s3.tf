#----- S3 Bucket --------
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.environment}-${var.customer}-${var.application_name}-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.environment}-${var.customer}-${var.application_name}-bucket"
      "service_role" = "s3"
    })
  )
}
