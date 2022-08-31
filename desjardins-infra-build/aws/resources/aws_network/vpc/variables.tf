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
  default     = ["namespace", "environment"]
  description = "The naming order of the id output and Name tag"
}

#
# Resource-specific
#
variable "availability_zones" {
  description = "List of availability zone names"
  type        = list(string)
}

variable "cidr_block" {
  description = "The CIDR block for the entire VPC"
  type        = string
}

variable "cidr_subnet_newbits" {
  description = "Additional bits to add to subnet mask"
  type        = number
}

variable "cidr_subnet_steps" {
  description = "Offset modifier amount"
  default     = null
  type        = number
}

variable "elastic_ips" {
  description = "The Elastic IP's to assign to the NAT gateway"
  type        = map(any)
}
