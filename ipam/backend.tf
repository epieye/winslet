//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "winslet"
    region = "us-east-1"
    profile = "ourzoo-root"
    key = "ipam_woznet.tfstate"
    acl = "bucket-owner-full-control"
  }
}
