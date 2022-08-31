output "json" {
  description = "Policy document in JSON"
  value       = data.aws_iam_policy_document.this.json
}
