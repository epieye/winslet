//bucket must be previously created.
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72.0"
      version = "< 4.0.0"
    }
  }

  backend "s3" {
    bucket = "ourzoo.us"
    region = "us-east-1"
    profile = "ourzoo-root"
    key = "woznet/web-server/s3.tfstate"
    acl = "bucket-owner-full-control"
  }
}
