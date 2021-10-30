data "terraform_remote_state" "woznet" {
  backend = "s3"
  config = {
    bucket = "kinaida.net"
    region = "us-east-1"
    key = "terraform.tfstate"
    profile = "default"
    acl = "bucket-owner-full-control"
  }
}
