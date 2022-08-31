output "arn" {
  description = "The bucket's ARN"
  value       = aws_s3_bucket.this.arn
}

output "fqdn" {
  description = "The bucket's FQDN"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "name" {
  description = "The bucket's name"
  value       = aws_s3_bucket.this.id
}
