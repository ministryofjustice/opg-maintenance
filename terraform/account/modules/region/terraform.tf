terraform {
  required_version = ">= 1.2.2"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.region,
      ]
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
