terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "zeitgeist-operations"
    key            = "full-stack-operations.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "zeitgeist-remote-state"
  }

  required_version = ">= 1.1.9"
}

provider "aws" {
  region = "eu-west-1"
}

