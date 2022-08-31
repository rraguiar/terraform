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
variable "label_order" {
  description = "The naming order of the id output and Name tag"
  default     = []
  type        = list(string)
}

variable "assuming_account_ids" {
  description = "List of account IDs authorized to assume account roles"
  type        = list(string)
}
