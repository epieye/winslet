//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "woznet-melbourne"
    region = "ap-southeast-4"
    profile = "OurzooAWSAdministratorAccess"
    key = "ap-southeast-4.tfstate"
    acl = "bucket-owner-full-control"
  }
}

