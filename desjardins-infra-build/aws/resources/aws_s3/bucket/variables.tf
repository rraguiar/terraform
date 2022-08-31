#
# Common vars
#
variable "namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  default     = ""
  type        = string
}

variable "stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  default     = ""
  type        = string
}

variable "environment" {
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  default     = ""
  type        = string
}

variable "name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
  type        = string
}

variable "tags" {
  description = "Key-value mapping of tags for the IAM role"
  default     = {}
  type        = map(any)
}

variable "label_order" {
  type        = list(string)
  default     = ["namespace", "environment", "name"]
  description = "The naming order of the id output and Name tag"
}

#
# Specific vars
#
variable "acl" {
  description = "The bucket ACL"
  default     = "private"
  type        = string
}

variable "acl_policy" {
  description = "The bucket public access policy"
  default     = {}
  type        = map(bool)
}

variable "cors_rules" {
  description = "List of cors rule complex objects"
  default     = []
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
}

variable "lifecycle_rules" {
  description = "List of lifecycle rule complex objects"
  default     = []
  type        = any
  # TODO -- Terraform crash
  # https://github.com/hashicorp/terraform/issues/22082
  #  type = list(object({
  #    id                    = string
  #    enabled               = bool
  #    prefix                = string
  #    tags                  = map(string)
  #    expiration            = map(any)
  #    transition            = list(map(any))
  #    noncurrent_expiration = map(any)
  #    noncurrent_transition = list(map(any))
  #  }))
}

variable "logging" {
  description = "The logging configuration directives"
  default     = null
  type = object({
    target_bucket = string
    target_prefix = string
  })
}

variable "override_name" {
  description = "Whether to override the bucket name"
  default     = false
  type        = bool
}

variable "override_tags" {
  description = "Overreride key-value mapping of tags for the IAM role"
  default     = {}
  type        = map(any)
}

variable "policy_enabled" {
  description = "Bucket policy should be created"
  default     = false
  type        = bool
}

variable "policy_json" {
  description = "Bucket policy JSON document"
  default     = null
  type        = string
}

variable "replication_configuration" {
  description = "List of Replication Configuration objects"
  default     = []
  type = list(object({
    account_id = string
    bucket_arn = string
    key_arn    = string
    role_arn   = string
  }))
}

variable "sse_algorithm" {
  description = "The encryption algorithm type"
  default     = "aws:kms"
  type        = string
}

variable "sse_key_arn" {
  description = "The ARN of the KMS key for bucket encryption"
  type        = string
}

variable "versioning_enabled" {
  description = "Whether to enable versioning on the bucket"
  default     = true
  type        = bool
}

variable "website" {
  description = "The website configuration directives"
  default     = null
  type = object({
    index_document           = string
    error_document           = string
    redirect_all_requests_to = string
  })
}
