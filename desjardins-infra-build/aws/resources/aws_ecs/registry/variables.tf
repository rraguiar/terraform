#
# Common vars
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
  description = "Solution name, e.g. 'app' or 'jenkins'"
  type        = string
}

variable "tags" {
  description = "Key-value mapping of tags for the IAM role"
  default     = {}
  type        = map(any)
}

#
# Specific vars
#
variable "max_image_count" {
  description = "Maximum amount of images in the ECR repository"
  default     = 20
}

variable "mutable_tags" {
  description = "Boolean indicating whether tags are mutable"
  default     = true
  type        = bool
}

variable "protected_tags" {
  description = "List of image tags we want to make sure never get reaped"
  type        = list(string)
  default     = ["develop", "staging", "master", "production"]
}

variable "read_principals" {
  description = "Principals allowed to read from the repository"
  default     = {}
  type        = map(any)
}

variable "scan_on_push" {
  description = "Performs OS-level vulnerability scanning when pushing images to ECR"
  default     = true
  type        = bool
}

variable "write_principals" {
  description = "Principals allowed to write from the repository"
  default     = {}
  type        = map(any)
}
