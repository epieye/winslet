//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "kinaida.net"
    region = "us-east-1"
    profile = "default"
    key = "terraform.tfstate"
    acl = "bucket-owner-full-control"
  }
}
