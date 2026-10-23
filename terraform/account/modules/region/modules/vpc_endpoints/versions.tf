terraform {
  required_version = "~> 1.17.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.region,
      ]
      version = ">= 6.28.0"
    }
  }
}
