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
variable "env_vars" {
  description = "Environment variables to supply to the build"
  type = list(object({
    name  = string # Environment variable's name or key.
    value = string # Environment variable's value.
    type  = string # Type of environment variable. Valid values: PARAMETER_STORE, PLAINTEXT, SECRETS_MANAGER.
  }))
  default = []
}

variable "source_location" {
  description = "URI of the source code from git or s3."
  type        = string
}

variable "source_version" {
  description = "Version of the build input to be built for this project. If not specified, the latest version is used."
  type        = string
  default     = "refs/heads/main"
}

variable "secrets_key_arn" {
  description = "ARN of the secrets KMS key"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs to assign to running builds."
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "Subnet IDs within which to run builds."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "ID of the VPC within which to run builds."
  type        = string
}
