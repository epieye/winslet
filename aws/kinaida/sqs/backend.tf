terraform {
  backend "s3" {
    bucket = "kinaida.net"
    region = "us-east-1"
    profile = "kinaida"
    key = "sqs.tfstate"
    acl = "bucket-owner-full-control"
  }
}

