//bucket must be previously created. How do I give access between kinaida and woznet/ourzoo?
terraform {
  backend "s3" {
    bucket = "kinaida.net"
    region = "us-east-1"
    profile = "default"
    key = "terraform.tfstate"
    acl = "bucket-owner-full-control"
  }
}
