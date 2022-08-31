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
variable "elastic_ips" {
  description = "The Elastic IP's to assign to the NAT gateway"
  type        = map(any)
}

variable "subnet_map" {
  description = "Mapping of AZ to subnet id"
  type        = map(string)
}
