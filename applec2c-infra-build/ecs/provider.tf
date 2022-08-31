# Define the Terraform version used in this code/infrastructure.
# Also, set the AWS Region where the infrastructure will be deployed.
provider "aws" {
  region = "ca-central-1"
}

# Set the location where the TFSTATE file will be saved and the DynamoDB table associated to the TFSTATE record. 
# Configuration required to protect the infrastructure and to ensure all DevOps can share the same state file.
terraform {
  backend "s3" {
    bucket         = "ep-infrastructure-apple-terraform-repository-s3"
    dynamodb_table = "ep-master-infrastructure-terraform-repository-table-apple"
    key            = "infrastructure/staging-infra-apple-infra-ecs.tfstate"
    region         = "ca-central-1"
  }
  required_providers {
    aws = "~> 3.31.0"
  }
  required_version = ">= 0.12"
}