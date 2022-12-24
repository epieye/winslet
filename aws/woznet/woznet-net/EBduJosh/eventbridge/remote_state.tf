data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "ourzoo.us"
    region = "us-east-1"
    key = "woznet-iam-temp.tfstate"
    profile = "default"
    acl = "bucket-owner-full-control"
  }
}
