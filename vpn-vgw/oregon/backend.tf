//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "ourzoo-test"
    region = "us-west-2"
    profile = "OurzooAWSAdministratorAccess"
    key = "vpn-oregon.tfstate"
    acl = "bucket-owner-full-control"
  }
}

