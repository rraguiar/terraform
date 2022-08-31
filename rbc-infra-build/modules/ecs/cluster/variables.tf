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
variable "asg_arns_private" {
  description = "ARNs of the private Autoscaling Groups for the capacity providers"
  type = object({
    ecs_node = string
  })
}

variable "asg_arns_public" {
  description = "ARNs of the public Autoscaling Groups for the capacity providers"
  type = object({
    ecs_node = string
  })
}

variable "s3_bucket_arns" {
  description = "ARNs of the S3 buckets we want the ECS cluster to access"
  type        = list(string)
  default     = []
}


variable "secrets_key_arn" {
  description = "ARN of the secrets KMS key"
  type        = string
}

variable "storage_key_arn" {
  description = "ARN of the storage KMS key"
  type        = string
}

# see: https://aws.amazon.com/blogs/containers/deep-dive-on-amazon-ecs-cluster-auto-scaling/
# CapacityProviderReservation =  M / N x 100, where M = instances needed, and N = instances running

variable "target_capacity_private" {
  description = "CapacityProviderReservation for the private services"
  type = object({
    ecs_node = number
  })
}

variable "target_capacity_public" {
  description = "CapacityProviderReservation for the public services"
  type = object({
    ecs_node = number
  })
}
