//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "ourzoo.us"
    region = "us-east-1"
    profile = "OurzooAWSAdministratorAccess"
    key = "irtgp/af-south-1.tfstate"
    acl = "bucket-owner-full-control"
  }
}

