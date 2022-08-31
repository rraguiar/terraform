# Fetch environment information and share with the components that will be deployed. 
# Collect the AWS Region name from providers.tf 
data "aws_region" "current" {}

# Collect the AZs available in the region
data "aws_availability_zones" "available" {}

# Collect the KMS (Key Encryption) information
data "aws_kms_alias" "ebs" {
  name = var.kms_key_id
}

# Collect the Certificate to be used on Load Balancer configuration
data "aws_acm_certificate" "issued" {
  #domain   = "${var.acm_domain_prefix}.${var.r53_domain}"
  domain   = "${var.environment}-${var.application_name}-c2c-api.${var.r53_domain}"
  statuses = ["ISSUED"]
}

# Collect Route 53 information
data "aws_route53_zone" "selected" {
  name         = var.r53_domain
  private_zone = false
}

data "aws_secretsmanager_secret" "db_admin_password" {
  arn = "arn:aws:secretsmanager:${data.aws_region.current.name}:${var.account_id}:secret:${var.application_name}/${var.environment}/db_admin_password"
}

# Collect secrets from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "db_admin_password" {
  secret_id = data.aws_secretsmanager_secret.db_admin_password.id
}
