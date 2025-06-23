//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "woznet-london"
    region = "eu-west-2"
    profile = "OurzooAWSAdministratorAccess"
    key = "woznet/transit-gateway/eu-west-2.tfstate"
    acl = "bucket-owner-full-control"
  }
}
