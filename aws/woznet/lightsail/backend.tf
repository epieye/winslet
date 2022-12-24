//bucket must be previously created.
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72.0"
    }
  }

  backend "s3" {
    bucket = "ourzoo.us"
    region = "us-east-1"
    profile = "ourzoo-root"
    key = "woznet/lightsail.tfstate"
    acl = "bucket-owner-full-control"
  }

  required_version = ">= 1.0.11"
}

