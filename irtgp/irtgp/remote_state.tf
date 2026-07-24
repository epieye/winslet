data "terraform_remote_state" "ashburn" {
  backend = "s3"
  config = {
    bucket  = "ourzoo.us"
    region  = "us-east-1"
    profile = "OurzooAWSAdministratorAccess"
    key     = "irtgp/us-east-1.tfstate"
    acl     = "bucket-owner-full-control"
  }
}

data "terraform_remote_state" "london" {
  backend = "s3"
  config = {
    bucket  = "ourzoo.us"
    region  = "us-east-1"
    profile = "OurzooAWSAdministratorAccess"
    key     = "irtgp/eu-west-2.tfstate"
    acl     = "bucket-owner-full-control"
  }
}

data "terraform_remote_state" "auckland" {
  backend = "s3"
  config = {
    bucket  = "ourzoo.us"
    region  = "us-east-1"
    profile = "OurzooAWSAdministratorAccess"
    key     = "irtgp/ap-southeast-6.tfstate"
    acl     = "bucket-owner-full-control"
  }
}

