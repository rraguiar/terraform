provider "aws" {
  allowed_account_ids = [var.aws.account_id]
  region              = var.aws.region

  assume_role {
    role_arn = var.aws.role_arn
  }
}

terraform {
  backend "s3" {}

  required_providers {
    aws = {
      version = "~> 2.70.0"
    }
  }
}
