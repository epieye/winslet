//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "ourzoo.us"
    region = "us-east-1"
    profile = "OurzooAWSAdministratorAccess"
    key = "woznet/site-to-site-vpn-vnet.tfstate"
    acl = "bucket-owner-full-control"
  }
}
