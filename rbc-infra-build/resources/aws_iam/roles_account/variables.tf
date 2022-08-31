#
# Labels
#
variable "namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  default     = ""
  type        = string
}

variable "stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  default     = ""
  type        = string
}

variable "environment" {
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
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
variable "assuming_account_ids" {
  description = "AWS account IDs authorized to assume roles"
  default     = []
  type        = list(string)
}

variable "max_session_duration" {
  description = "Maximum assume role session duration"
  default     = 43200 # 12 hours
  type        = number
}

#
# Superuser
#
variable "superuser_policy_arns" {
  description = "List of policy arns to assign to superuser role"
  default = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  type = list(string)
}

variable "superuser_policy_map" {
  description = "Map of IAM policies to assign to superuser role"
  default     = {}
  type        = map(string)
}

#
# Developer
#
variable "developer_policy_arns" {
  description = "List of policy arns to assign to developer role"
  default = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
  ]
  type = list(string)
}

variable "developer_policy_map" {
  description = "Map of IAM policies to assign to developer role"
  default     = {}
  type        = map(string)
}

#
# Readonly
#
variable "readonly_policy_arns" {
  description = "List of policy arns to assign to readonly role"
  default = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
  type = list(string)
}

variable "readonly_policy_map" {
  description = "Map of IAM policies to assign to readonly role"
  default     = {}
  type        = map(string)
}

#
# Terraform
#
variable "terraform_policy_arns" {
  description = "List of policy arns to assign to terraform role"
  default = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  type = list(string)
}

variable "terraform_policy_map" {
  description = "Map of IAM policies to assign to terraform role"
  default     = {}
  type        = map(string)
}
