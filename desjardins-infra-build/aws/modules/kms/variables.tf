variable "aws" {
  description = "AWS provider variables"
  type = object({
    account_id = string
    region     = string
    role_arn   = string
  })
}

variable "label" {
  description = "Label variables"
  type = object({
    namespace   = string
    stage       = string
    environment = string
    name        = string
    tags        = map(string)
  })
}
#
# Specific vars
#
variable "secrets_principals" {
  description = "The KMS key principals for the secrets key"
  default     = {}
  type        = map(any)
}

variable "storage_principals" {
  description = "The KMS key principals for the storage key"
  default     = {}
  type        = map(any)
}
