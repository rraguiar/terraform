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
    organization = string
    namespace    = string
    stage        = string
    environment  = string
    name         = string
    tags         = map(string)
  })
}

#
# Specific vars
#
variable "subnet_cidrs" {
  description = "Map of tier to subnet CIDR range"
  type        = map(list(string))
}

variable "subnet_ids" {
  description = "Map of VPC subnet_ids"
  type        = map(list(string))
}

variable "storage_key_arn" {
  description = "ARN of the storage KMS key"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
