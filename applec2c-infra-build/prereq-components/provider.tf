# Terraform configuration
# Define the AWS Region where the infrastructure will be deployed
provider "aws" {
  region = var.aws_region
}

# Define the S3 and DynamoDB where the Terraform state file will be stored.
terraform {
  backend "s3" {
    bucket         = "ep-infrastructure-apple-terraform-repository-s3"
    dynamodb_table = "ep-master-infrastructure-terraform-repository-table-apple"
    key            = "infrastructure/staging-apple-prereq-components.tfstate"
    region         = "ca-central-1"
  }
  required_providers {
    aws = "~> 3.31.0"
  }
  required_version = ">= 0.12" # Define the required Terraform version to execute the deployment.
}