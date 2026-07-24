data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket  = "ourzoo.us"
    region  = "us-east-1"
    profile = "OurzooAWSAdministratorAccess"
    key     = "irtgp/iam-common.tfstate"
    acl     = "bucket-owner-full-control"
  }
}

