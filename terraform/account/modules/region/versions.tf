terraform {
  required_version = ">= 1.2.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.66.0"
      configuration_aliases = [
        aws.region,
        aws.management,
      ]
    }
  }
}
