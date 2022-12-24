//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "kinaida.net"
    region = "us-east-1"
    profile = "kinaida"
    key = "kinaida-s3.tfstate"
    acl = "bucket-owner-full-control"
  }
}
