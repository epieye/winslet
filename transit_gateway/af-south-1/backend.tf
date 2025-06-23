//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "woznet-capetown"
    region = "af-south-1"
    profile = "OurzooAWSAdministratorAccess"
    key = "af-south-1.tfstate"
    acl = "bucket-owner-full-control"
  }
}
