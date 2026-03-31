terraform {
  backend "s3" {
    bucket = "mys3bucketforstatefile-1226"
    dynamodb_table = "state-lock"
    key = "Global/monitoring/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}