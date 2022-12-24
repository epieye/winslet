data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "ourzoo.us"
    region = "us-east-1"
    key = "woznet/api-server/iam.tfstate"
    profile = "default"
    acl = "bucket-owner-full-control"
  }
}
