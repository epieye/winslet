//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "ourzoo.us"
    region = "us-east-1"
    profile = "ourzoo-root"
    key = "kinaida-lb.tfstate"
    acl = "bucket-owner-full-control"
  }
}
