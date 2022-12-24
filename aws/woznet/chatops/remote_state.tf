data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "ourzoo.us"
    region = "us-east-1"
    key = "woznet/chatops/iam.tfstate"
    profile = "default"
    acl = "bucket-owner-full-control"
  }
}

data "terraform_remote_state" "api_gateway" {
  backend = "s3"
  config = {
    bucket = "ourzoo.us"
    region = "us-east-1"
    key = "woznet/chatops/apigateway.tfstate"
    profile = "default"
    acl = "bucket-owner-full-control"
  }
}
