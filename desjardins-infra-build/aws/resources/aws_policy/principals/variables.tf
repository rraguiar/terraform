variable "account_ids" {
  description = "List of AWS account ids"
  default     = []
  type        = list(string)
}

variable "aws" {
  description = "List of AWS user, role, or account arns"
  default     = []
  type        = list(string)
}

variable "canonical_user" {
  description = "List of Canonical User ids"
  default     = []
  type        = list(string)
}

variable "federated" {
  description = "List of federation URLs"
  default     = []
  type        = list(string)
}

variable "service" {
  description = "List of service URLs"
  default     = []
  type        = list(string)
}

variable "principals" {
  description = "Map of principals"
  default     = {}
  type        = map(any)
}
