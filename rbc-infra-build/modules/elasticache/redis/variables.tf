variable "aws" {
  description = "AWS provider variables"
  type = object({
    account_id = string
    region     = string
    role_arn   = string
  })
}

variable "label" {
  description = "Label variables"
  type = object({
    organization = string
    namespace    = string
    stage        = string
    environment  = string
    name         = string
    tags         = map(string)
  })
}

#
# Specific vars
#
variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "Availability zone IDs"
  type        = list(string)
  default     = []
}

variable "cluster_size" {
  description = "Number of nodes in cluster. Ignored when cluster_mode_enabled == true"
  type        = number
  default     = 1
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
}

variable "family" {
  description = "Redis family"
  type        = string
}

variable "instance_type" {
  description = "Elasticache instance type"
  type        = string
  default     = "cache.t3.micro"
}

variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "List of Security Group IDs that are allowed ingress"
  type        = list(string)
  default     = []
}

variable "security_group_rules" {
  description = "A list of maps of Security Group rules."
  type        = list(any)
  default     = []
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "storage_key_arn" {
  description = "ARN of the KMS key used to encrypt data at rest"
  type        = string
  default     = null
}

variable "transit_encryption_enabled" {
  description = "Whether to enable encryption in transit."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
