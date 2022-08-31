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
variable "ami_name" {
  description = "AMI name prefix to lookup"
  type        = string
}

variable "ami_instance_type" {
  description = "The AMI instance type"
  type        = string
}

variable "ami_owners" {
  description = "List of AMI owner account IDs"
  type        = list(string)
}

variable "target_capacity" {
  description = "Nb. of desired EC2 instances in the ASG capacity providers"
  type = object({
    public = object({
      min = number
      max = number
    })
    private = object({
      min = number
      max = number
    })
  })
}

variable "security_group_rules_public" {
  description = "List of security group rules to create for the public ASG"
  default     = {}
  type        = map(map(string))
}

variable "security_group_rules_private" {
  description = "List of security group rules to create for the private ASG"
  default     = {}
  type        = map(map(string))
}

variable "subnet_ids" {
  description = "Mapping of public/private subnets in the VPC"
  type = object({
    private = list(string)
    public  = list(string)
  })
}

variable "vpc_id" {
  description = "ID of the VPC which will host the ASG's"
  type        = string
}
