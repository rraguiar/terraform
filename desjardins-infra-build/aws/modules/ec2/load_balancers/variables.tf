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
    namespace   = string
    stage       = string
    environment = string
    name        = string
    tags        = map(string)
  })
}

#
# Specific vars
#
variable "certificate_arn" {
  description = "The ARN of the default SSL server certificate"
  default     = null
  type        = string
}

variable "lb_access_logs" {
  description = "Map of load balancer access log configurations"
  default = {
    bucket  = null
    prefix  = ""
    enabled = false
  }
  type = object({
    bucket  = string
    prefix  = string
    enabled = bool
  })
}

variable "lb_alias" {
  description = "The Alias DNS record to create for the Load Balancer"
  type = object({
    fqdn    = string
    zone_id = string
  })
  default = null
}

variable "lb_healthcheck" {
  description = "A Health Check block"
  default     = {}
  type        = map(string)
}

variable "lb_idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  default     = 120
  type        = number
}

variable "lb_internal" {
  description = "Whether the Network Load Balancer is internal (private) or not (public)"
  default     = true
  type        = bool
}

variable "lb_listeners" {
  description = "Map of LB listener specs"
  type = map(list(object({
    port     = string
    protocol = string
  })))
}

variable "lb_targets" {
  description = "Map of LB target specs"
  type = map(list(object({
    port     = string
    protocol = string
    type     = string
  })))
}

variable "lb_type" {
  description = "Type of load balancer to create, either: application, or network"
  type        = string
}

variable "security_group_ids" {
  description = "The Security Group ID's for the Load Balancer to join. ALB only."
  default     = []
  type        = list(string)
}

variable "subnet_ids" {
  description = "Map of VPC subnet_ids"
  type = object({
    private = list(string)
    public  = list(string)
  })
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
