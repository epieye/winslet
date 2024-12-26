//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "ourzoo.us"
    region = "us-east-2"
    profile = "OurzooAWSAdministratorAccess"
    key = "woznet/vpc-peering.tfstate"
    acl = "bucket-owner-full-control"
  }
}