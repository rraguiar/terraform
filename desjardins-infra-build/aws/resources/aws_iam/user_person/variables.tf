#
# Labels
#
variable "namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  default     = ""
  type        = string
}

variable "stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  default     = ""
  type        = string
}

variable "environment" {
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  default     = ""
  type        = string
}

variable "name" {
  description = "Desired name for the IAM user. We recommend using email addresses."
  type        = string
}

variable "tags" {
  description = "Key-value mapping of tags for the IAM role"
  default     = {}
  type        = map(string)
}

#
# Specific vars
#
variable "path" {
  description = "Desired path for the IAM user"
  default     = "/"
  type        = string
}

variable "enabled" {
  description = "Whether to create the IAM user"
  default     = true
  type        = bool
}

variable "force_destroy" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed."
  default     = false
  type        = bool
}

variable "groups" {
  description = "List of IAM user groups this user should belong to in the account"
  type        = list(any)
  default     = []
}

variable "login_profile_enabled" {
  description = "Whether to create IAM user login profile"
  default     = true
  type        = bool
}

variable "password_length" {
  description = "The length of the generated password"
  default     = 24
}

variable "password_reset_required" {
  description = "Whether the user should be forced to reset the generated password on first login."
  default     = true
}

variable "permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the user"
  default     = null
  type        = string
}

variable "pgp_key" {
  description = "Provide a base-64 encoded PGP public key. Required to encrypt password."
  default     = "keybase:manafont" # my default public PGP key, see: https://keybase.io/manafont
  type        = string
}

variable "ssh_public_key" {
  description = "Desired SSH public key for the IAM user"
  default     = null
  type        = string
}
