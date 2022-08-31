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
  default     = ["namespace", "environment", "name"]
  description = "The naming order of the id output and Name tag"
}

#
# Specific vars
#
variable "access_logs" {
  description = "Map of load balancer access log configurations"
  default = {
    bucket  = null
    prefix  = null
    enabled = false
  }
  type = object({
    bucket  = string
    prefix  = string
    enabled = bool
  })
}

variable "alias" {
  description = "The Alias DNS record to create for the Load Balancer"
  type = object({
    fqdn    = string
    zone_id = string
  })
  default = null
}

variable "enable_cross_zone_load_balancing" {
  description = "Boolean indicating whether to enable cross-zone load balancing"
  default     = true
  type        = bool
}

variable "enable_deletion_protection" {
  description = "Boolean indicating whether the NLB should be protected"
  default     = false
  type        = bool
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  default     = 60
  type        = number
}

variable "internal" {
  description = "Boolean dictating whether this NLB is private or public"
  default     = true
  type        = bool
}

variable "ip_address_type" {
  description = "The type of IP addressed used by the subnets, ipv4 or dualstack"
  default     = "ipv4"
  type        = string
}

variable "load_balancer_type" {
  description = "Type of load balancer to create, either: application, or network"
  type        = string
}

variable "security_group_ids" {
  description = "The Security Group ID's for the Load Balancer to join. ALB only."
  default     = []
  type        = list(string)
}

variable "subnet_mappings" {
  description = "List of maps of subnet mappings"
  default     = []
  type = list(
    object({
      subnet_id     = string
      allocation_id = string
    })
  )
}
