variable "actions" {
  description = "List of assumeable actions"
  default = [
    "sts:AssumeRole",
    "sts:TagSession",
  ]
  type = list(string)
}

variable "conditions" {
  description = "List of optional conditions to apply to role assumption"
  default     = []
  type = list(object({
    test     = string
    values   = list(string)
    variable = string
  }))
}

variable "principals" {
  description = "Map of principals allowed to assume this role"
  default = {
    account        = []
    aws            = []
    canonical_user = []
    federated      = []
    service        = []
  }
  type = map(list(string))
}
