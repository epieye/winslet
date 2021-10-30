//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "ourzoo.us"
    region = "us-east-1"
    profile = "default"
    key = "ourzoo.tfstate"
    acl = "bucket-owner-full-control"
  }
}
