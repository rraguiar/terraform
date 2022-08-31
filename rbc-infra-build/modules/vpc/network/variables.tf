variable "aws" {
  description = "AWS provider variables"
  type = object({
    account_id     = string
    region         = string
    role_arn       = string
    vpc_default_id = string
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
variable "vpc_availability_zones" {
  description = "List of availability zone names to deploy into"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the entire VPC"
  type        = string
}

variable "vpc_cidr_subnet_newbits" {
  description = "Additional bits to add to subnet mask"
  type        = number
}

variable "vpc_cidr_subnet_steps" {
  description = "Amount of subnets to offset per tier"
  type        = number
}

variable "vpc_elastic_ips" {
  description = "The Elastic IP's to assign to the NAT gateway"
  type        = map(any)
}
