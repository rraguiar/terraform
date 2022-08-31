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
variable "description" {
  description = "The description for this resource"
  default     = null
  type        = string
}

variable "revoke_rules_on_delete" {
  description = "Revole alll Security Groups attached ingress and egress rules before deleting the rule itself"
  default     = true
  type        = bool
}

variable "rules" {
  description = "List of Security Group rules to create"
  default     = {}
  type        = map(map(string))
}

variable "trust_targets" {
  description = "List of Security Group rule targets to implicitly trust"
  default     = {}
  type        = map(map(string))
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
