module "label" {
  source = "../../aws_data/label"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  tags        = var.tags

  label_order = var.label_order
}

locals {
  acl_policy = merge(
    (var.acl == "public"
      ? local.default_public_policy
      : local.default_private_policy
    ), var.acl_policy
  )

  default_private_policy = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

  default_public_policy = {
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }

  encryption_config_kms = (
    var.sse_key_arn == null
    ? []
    : [{
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.sse_key_arn
    }]
  )

  encryption_config_aes256 = (
    var.sse_key_arn == null && var.sse_algorithm == "AES256"
    ? [{
      sse_algorithm = var.sse_algorithm
    }]
    : []
  )
}

resource "aws_s3_bucket" "this" {
  bucket = (
    var.override_name == true
    ? var.name
    : module.label.id
  )

  acl           = var.acl
  force_destroy = false

  dynamic "cors_rule" {
    for_each = var.cors_rules
    iterator = cors

    content {
      allowed_headers = cors.value.allowed_headers
      allowed_methods = cors.value.allowed_methods
      allowed_origins = cors.value.allowed_origins
      expose_headers  = cors.value.expose_headers
      max_age_seconds = cors.value.max_age_seconds
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    iterator = rule

    content {
      id      = rule.value.id
      enabled = lookup(rule.value, "enabled", true)
      prefix  = lookup(rule.value, "prefix", null)
      tags    = lookup(rule.value, "tags", null)

      abort_incomplete_multipart_upload_days = lookup(rule.value, "abort_incomplete_multipart_upload_days", null)

      dynamic "expiration" {
        for_each = (
          lookup(rule.value, "expiration", null) == null
          ? []
          : [rule.value.expiration]
        )
        iterator = expiration

        content {
          days = expiration.value.days
        }
      }

      dynamic "transition" {
        for_each = (
          lookup(rule.value, "transition", null) == null
          ? []
          : rule.value.transition
        )

        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = (
          lookup(rule.value, "noncurrent_expiration", null) == null
          ? []
          : [rule.value.noncurrent_expiration]
        )
        iterator = noncurrent_expiration

        content {
          days = noncurrent_expiration.value.days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = (
          lookup(rule.value, "noncurrent_transition", null) == null
          ? []
          : rule.value.noncurrent_transition
        )
        iterator = noncurrent_transition

        content {
          days          = noncurrent_transition.value.days
          storage_class = noncurrent_transition.value.storage_class
        }
      }
    }
  }

  dynamic "logging" {
    for_each = var.logging == null ? [] : [var.logging]
    iterator = rule

    content {
      target_bucket = rule.value.target_bucket
      target_prefix = rule.value.target_prefix
    }
  }

  dynamic "replication_configuration" {
    for_each = var.replication_configuration
    iterator = rep

    content {
      role = rep.value.role_arn

      rules {
        id     = "replicate"
        prefix = ""
        status = "Enabled"

        destination {
          account_id         = rep.value.account_id
          bucket             = rep.value.bucket_arn
          replica_kms_key_id = rep.value.key_arn
          storage_class      = "STANDARD"

          access_control_translation {
            owner = "Destination"
          }
        }

        source_selection_criteria {
          sse_kms_encrypted_objects {
            enabled = var.sse_key_arn == null ? false : true
          }
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = local.encryption_config_kms
    iterator = sse_config

    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = sse_config.value.kms_master_key_id
          sse_algorithm     = sse_config.value.sse_algorithm
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = local.encryption_config_aes256
    iterator = aes256_config

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = aes256_config.value.sse_algorithm
        }
      }
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "website" {
    for_each = var.website == null ? [] : [var.website]
    iterator = rule

    content {
      index_document           = rule.value.index_document
      error_document           = rule.value.error_document
      redirect_all_requests_to = rule.value.redirect_all_requests_to
    }
  }

  tags = merge(
    module.label.tags,
    var.override_tags
  )
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.policy_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = var.policy_json
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = local.acl_policy.block_public_acls
  block_public_policy     = local.acl_policy.block_public_policy
  ignore_public_acls      = local.acl_policy.ignore_public_acls
  restrict_public_buckets = local.acl_policy.restrict_public_buckets
}
