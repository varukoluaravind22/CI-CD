terraform {
  backend "s3" {
    bucket = "Mys3bucketforstatefile"
    dynamodb_endpoint = "state-lock"
    key = "Global/mystatefile/terraform.tfstate"
    region="ap-south-1"
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