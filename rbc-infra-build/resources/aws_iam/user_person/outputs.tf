output "arn" {
  description = "The ARN assigned by AWS for this user"
  value       = element(concat(aws_iam_user.this[*].arn, list("")), 0)
}

output "name" {
  description = "The user's name"
  value       = element(concat(aws_iam_user.this[*].name, list("")), 0)
}

output "groups" {
  description = "The list of IAM groups the user belongs to"
  value       = distinct(concat(aws_iam_user_group_membership.this[*].groups))
}
