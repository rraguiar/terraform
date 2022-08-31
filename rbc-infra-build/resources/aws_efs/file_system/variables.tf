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
  type        = map(string)
}

variable "label_order" {
  type        = list(string)
  default     = ["stage", "namespace", "environment", "name"]
  description = "The naming order of the id output and Name tag"
}

#
# Specific vars
#
variable "kms_key_id" {
  description = "The ARN of the KMS key to associate"
  type        = string
}

variable "performance_mode" {
  description = "The EFS performance mode"
  default     = "generalPurpose"
  type        = string
}

variable "throughput_mode" {
  description = "The EFS throughput mode"
  default     = "bursting"
  type        = string
}

variable "security_group_ids" {
  description = "List of additional security groups to be a member of"
  default     = []
  type        = list(string)
}

variable "security_group_rules" {
  description = "List of security group rules to create"
  default     = {}
  type        = map(map(string))
}

variable "security_group_targets" {
  description = "List of security group trust rules to create"
  default     = {}
  type        = map(map(string))
}

variable "subnet_ids" {
  description = "List of subnet ids"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
