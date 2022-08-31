variable "partition" {
  type        = string
  description = "The partition that the resource is in"
  default     = "aws"
}

variable "service" {
  type        = string
  description = "The service namespace that identifies the AWS product"
  default     = ""
}

variable "region" {
  type        = string
  description = "The Region that the resource resides in"
  default     = ""
}

variable "account" {
  type        = string
  description = "The ID of the AWS account that owns the resource, without the hyphens"
  default     = ""
}

variable "path" {
  type        = list(any)
  description = "The path of the resource"
  default     = []
}

variable "path_delimiter" {
  type        = string
  description = "Delimiter used when joining path elements"
  default     = "/"
}
