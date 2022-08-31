variable "account_id" {
  description = "List of account ids to use as a default"
  type        = string
}

variable "policy_principals" {
  description = "Map of policy principals, owner, encrypt, decrypt, grant"
  default     = {}
  type        = map(map(list(string)))
}
