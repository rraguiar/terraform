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

variable "attributes" {
  description = "Additional attributes (e.g. `1`)"
  default     = []
  type        = list(string)
}

variable "label_order" {
  type        = list(string)
  default     = ["stage", "namespace", "environment", "name"]
  description = "The naming order of the id output and Name tag"
}

#
# Specific vars
#

variable "capacity_providers" {
  description = " List of short names of one or more capacity providers to associate with the cluster"
  type        = list(string)
}

variable "secrets_key_arn" {
  description = "ARN of the secrets KMS key"
  type        = string
}

variable "storage_key_arn" {
  description = "ARN of the storage KMS key"
  type        = string
}

variable "s3_bucket_arns" {
  description = "ARNs of the S3 buckets we want the ECS cluster to access"
  type        = list(string)
  default     = []
}
