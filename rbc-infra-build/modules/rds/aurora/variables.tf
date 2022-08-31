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
variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the cluster"
  type        = list(string)
  default     = []
}

variable "cluster_family" {
  description = "The family of the DB cluster parameter group"
  type        = string
}

variable "cluster_size" {
  description = "Number of DB instances to create in the cluster"
  type        = number
}

variable "db_admin_user" {
  description = "The name of the Admin user"
  type        = string
  default     = "admin"
}

variable "db_admin_password_secret" {
  description = "ARN of the Secret containing the DB Admin password"
  type        = string
}

variable "db_name_secret" {
  description = "ARN of the Secret containing the DB name"
  type        = string
}

variable "db_port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 3306
}

variable "engine" {
  description = "The name of the database engine to be used for this DB cluster. Valid values: aurora, aurora-mysql, aurora-postgresql"
  type        = string
}

variable "engine_version" {
  description = "The version of the database engine to use. See aws rds describe-db-engine-versions"
  type        = string
}

variable "instance_type" {
  description = "Instance type to use"
  type        = string
}

variable "route53_zone_id" {
  description = "The ID of the Route53 Hosted Zone where a new DNS record will be created for the DB host name."
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "List of security groups IDs to be allowed to connect to the DB instance"
  type        = list(string)
  default     = []
}

variable "storage_key_arn" {
  description = "ARN of the KMS key used to encrypt the data at rest"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of VPC subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID to create the cluster in"
  type        = string
}
