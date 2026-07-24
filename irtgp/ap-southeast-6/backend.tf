//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "ourzoo.us"
    region = "us-east-1" # The bucket is in this region. Not local.region.
    profile = "OurzooAWSAdministratorAccess"
    key = "irtgp/ap-southeast-6.tfstate"
    acl = "bucket-owner-full-control"
  }
}
