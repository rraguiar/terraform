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
  description = "The naming order of the id output and Name tag"
  default     = ["stage", "namespace", "environment", "name"]
  type        = list(string)
}

#
# Specific vars
#
variable "cidr_block" {
  description = "CIDR block for the vpc"
  type        = string
}

variable "cidr_subnet_newbits" {
  description = "Additional bits to add to subnet mask"
  type        = number
}

variable "cidr_subnet_offset" {
  description = "Offset count when generating subnet CIDRs"
  type        = number
}

variable "cidr_subnet_steps" {
  description = "Offset modifier amount"
  default     = null
  type        = number
}

variable "availability_zones" {
  description = "List of availability zones into which to create subnets"
  type        = list(string)
}

variable "map_ip_on_launch" {
  description = "Boolean indicating whether to provide public ips to instances"
  default     = false
  type        = bool
}

variable "map_s3_endpoint" {
  description = "Boolean dictating whether to add routes for s3 endpoint"
  default     = false
  type        = bool
}

variable "map_nat_gateways" {
  description = "Boolean dictating whether to add routes for nat gateways"
  default     = false
  type        = bool
}

variable "nat_gateway_ids" {
  description = "Map of AZ to NAT gateways to create routes for"
  default     = {}
  type        = map(string)
}

variable "s3_endpoint_id" {
  description = "ID of the S3 endpoint to associate to the tier"
  default     = null
  type        = string
}

variable "vpc_id" {
  description = "ID of the vpc"
  type        = string
}

