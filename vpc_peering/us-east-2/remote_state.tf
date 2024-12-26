

data "terraform_remote_state" "ourzoo" {
  backend = "s3"
  config = {
    bucket  = "ourzoo.us"
    region  = "us-east-1"
    profile = "OurzooAWSAdministratorAccess"
    key     = "woznet/vpc-peering.tfstate"
    acl     = "bucket-owner-full-control"
  }
}

