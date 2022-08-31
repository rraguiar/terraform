#
# Labels
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
variable "conditions" {
  description = "List of optional conditions to apply to role assumption"
  default     = []
  type = list(object({
    test     = string
    values   = list(string)
    variable = string
  }))
}

variable "path" {
  description = "The path to the role"
  default     = "/"
  type        = string
}

variable "principals" {
  description = "Map of AWS principal ids which may assume this role"
  type        = map(list(string))
  default = {
    account        = []
    aws            = []
    canonical_user = []
    federated      = []
    service        = []
  }
}

variable "description" {
  description = "The description of the role"
  default     = null
  type        = string
}

variable "force_detach_policies" {
  description = "Specifies to force detaching any policies the role has before destroying"
  default     = false
  type        = bool
}

variable "permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the role"
  default     = null
  type        = string
}

variable "policy_arns" {
  description = "List of IAM policies to attach to this role"
  default     = []
  type        = list(string)
}

variable "policy_map" {
  description = "Map of IAM policies to assign to this role"
  default     = {}
  type        = map(string)
}

variable "max_session_duration" {
  description = "The maximum session duration (in seconds) that you want to set for the specified role"
  default     = 3600
  type        = number
}
