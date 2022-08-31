#
# Common vars
#
variable "namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  default     = ""
  type        = string
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
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
  description = "The naming order of the id output and Name tag"
  default     = ["namespace", "environment", "name"]
  type        = list(string)
}

#
# Specific vars
#
variable "description" {
  description = "The description string"
  default     = null
  type        = string
}

variable "key_arn" {
  description = "The ID of the KMS key to encrypt values with"
  default     = null
  type        = string
}

variable "overwrite" {
  description = "Should unmanaged parameters be overwritten"
  default     = true
  type        = bool
}

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
