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
variable "read_principals" {
  description = "ECR repository policy principals allowed to read repos"
  type        = map(any)
}

variable "write_principals" {
  description = "ECR repository policy principals allowed to write repos"
  type        = map(any)
}
