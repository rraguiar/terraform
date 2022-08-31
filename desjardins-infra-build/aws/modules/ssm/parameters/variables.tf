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
variable "parameters" {
  description = "Map of parameters to create"
  #
  # parameters = {
  #   key_suffix = {
  #     type  = SecureString | String
  #     value = parameter value
  #   }
  # }
  type = map(map(string))
}

variable "secrets_key_arn" {
  description = "ARN of the secrets KMS key"
  type        = string
}
