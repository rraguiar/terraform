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
variable "security_group_rules" {
  description = "Map of security group rules to create"
  default     = {}
  type        = map(map(string))
}

variable "security_group_targets" {
  description = "List of security group trust rules to create"
  default     = {}
  type        = map(map(string))
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
