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
variable "develop_role_arns" {
  type = object({
    developer = string,
    read_only = string,
    superuser = string,
    terraform = string,
  })
  default = {
    developer = ""
    read_only = "",
    superuser = "",
    terraform = "",
  }
}
