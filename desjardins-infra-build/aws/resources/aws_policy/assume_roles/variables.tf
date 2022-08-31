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
  default     = ["namespace", "stage", "name"]
  type        = list(string)
}

#
# Specific vars
#
variable "path" {
  description = "Name of the policy arn name prefix"
  default     = "/"
  type        = string
}

variable "description" {
  description = "Description of the IAM policy"
  default     = null
  type        = string
}

variable "require_mfa" {
  description = "Boolean used to restrict role assumption to MFA"
  default     = true
  type        = bool
}

variable "role_arns" {
  description = "List of IAM roles that may be assumed"
  type        = list(string)
}
