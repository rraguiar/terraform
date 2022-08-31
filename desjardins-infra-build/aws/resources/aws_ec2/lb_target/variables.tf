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

variable "attributes" {
  description = "Additional attributes (e.g. `1`)"
  default     = []
  type        = list(string)
}

variable "label_order" {
  type        = list(string)
  default     = ["namespace", "environment", "name", "attributes"]
  description = "The naming order of the id output and Name tag"
}

#
# Specific vars
#
variable "autoscaling_group_names" {
  description = "The Name of the autoscaling group"
  default     = []
  type        = list(string)
}

variable "certificate_arn" {
  description = "The ARN of the default SSL server certificate"
  default     = null
  type        = string
}

variable "deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before shutting down"
  default     = 60
  type        = number
}

variable "health_check" {
  description = "A Health Check block"
  default     = {}
  type        = map(string)
}

variable "load_balancer" {
  description = "The load balancer object"
}

variable "load_balancer_arn" {
  description = "The ARN of the load balancer"
  type        = string
}

variable "listeners" {
  description = "Map of LB listener specs"
  type = map(list(object({
    port     = string
    protocol = string
  })))
}

variable "proxy_protocol_v2" {
  description = "Boolean to enable / disable support for proxy protocol v2"
  default     = null
  type        = bool
}

variable "ssl_policy" {
  description = "The name of the SSL policy for the listener"
  default     = "ELBSecurityPolicy-2016-08"
  type        = string
}

variable "targets" {
  description = "Map of LB target specs"
  type = map(list(object({
    port     = string
    protocol = string
    type     = string
  })))
}

variable "vpc_id" {
  description = "The identifier of the VPC in which to create the target group"
  type        = string
}
