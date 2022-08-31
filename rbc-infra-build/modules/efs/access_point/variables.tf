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
