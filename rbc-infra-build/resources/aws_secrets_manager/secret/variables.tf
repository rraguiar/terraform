#
# Common vars
#
variable "namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  type        = string
}

variable "stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  type        = string
}

variable "environment" {
  description = "Environment name, ex.: use1prod, usw2stag"
  default     = ""
  type        = string
}

variable "name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
  type        = string
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
  default     = {}
  type        = map(string)
}

variable "label_order" {
  description = "The naming order of the id output and Name tag"
  default     = ["stage", "namespace", "environment", "name"]
  type        = list(string)
}

#
# Specific vars
#
variable "secrets_key_arn" {
  description = "The ARN of the KMS key used to encrypt / decrypt the secret"
  type        = string
}

variable "secret_string" {
  description = "The secret value"
  type        = string
  default     = "UNDEFINED"
}
