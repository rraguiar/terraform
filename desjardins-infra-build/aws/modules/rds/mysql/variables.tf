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
variable "allocated_storage" {
  description = "The allocated storage in GBs"
  type        = number
  default     = 100
}

variable "auto_minor_version_upgrade" {
  description = "Allow automated minor version upgrade"
  type        = bool
  default     = false
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrade"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false # next window
}

variable "backup_retention_period" {
  type        = number
  description = "Backup retention period in days. Must be > 0 to enable backups"
  default     = 0
}

variable "ca_cert_identitier" {
  description = "The identifier of the CA certificate for the DB instance"
  type        = string
  default     = "rds-ca-2019"
}

variable "db_name" {
  description = "The database name"
  type        = string
}

variable "db_host_name" {
  description = "The database instance's Route53 host name"
  type        = string
  default     = null
}

variable "db_parameter_group" {
  description = "The DB parameter group family name. The value depends on DB engine used."
  type        = string
}

variable "db_passwd_ssm" {
  description = "The name of the SSM parameter containing the DB password"
  type        = string
}

variable "db_port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 3306
}

variable "db_user_ssm" {
  description = "The name of the SSM parameter containing the DB user"
  type        = string
}

variable "dns_zone_id" {
  description = "The ID of the DNS Zone in Route53 where a new DNS record will be created for the DB host name."
  type        = string
  default     = ""
}

variable "enabled_cloudwatch_logs_exports" {
  type = list(string)
  default = [
    "audit",
    "error",
    "general",
    "slowquery"
  ]
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
}

variable "engine" {
  description = "Database engine type"
  type        = string
}

variable "engine_version" {
  description = "Database engine version, depends on engine type"
  type        = string
}

variable "instance_class" {
  description = "DB instance class to use."
  type        = string
}

variable "multi_az" {
  description = "Set to true if multi AZ deployment must be supported"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Set to true if you want your cluster to be publicly accessible"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security groups IDs to be allowed to connect to the DB instance"
  type        = list(string)
  default     = []
}

variable "snapshot_identifier" {
  description = "Source Snapshot ID. If specified, the module creates the cluster from the snapshot"
  type        = string
  default     = null
}

variable "storage_key_arn" {
  description = "The ARN for the KMS encryption key."
  type        = string
  default     = null
}

variable "storage_type" {
  description = "The DB disk media"
  type        = string
  default     = "gp2"
}

variable "subnet_ids" {
  description = "List of VPC subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID to create the cluster in"
  type        = string
}
