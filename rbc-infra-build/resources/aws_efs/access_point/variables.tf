#
# Labels
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
  default     = ["stage", "namespace", "environment", "name"]
  description = "The naming order of the id output and Name tag"
}

#
# Specific vars
#
variable "file_system_id" {
  description = "The ID of the file system"
  type        = string
}

variable "permissions" {
  description = "The CHMOD of the EFS mount"
  type        = string
  default     = "0755"
}

variable "posix_user" {
  description = "The operating system user:group applied to all file system requests"
  type = object({
    gid            = string
    uid            = string
    secondary_gids = list(string)
  })
}

variable "root_directory" {
  description = "The subdirectory to create the access point for"
  type        = string
}
