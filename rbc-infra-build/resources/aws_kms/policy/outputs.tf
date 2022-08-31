output "json" {
  description = "The JSON policy document"
  value       = data.aws_iam_policy_document.this.json
}
