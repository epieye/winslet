//bucket must be previously created.
terraform {
  backend "s3" {
    bucket = "woznet-london" # do I need a stokholm bucket too? Or just not change this setting?
    region = "eu-west-2"
    profile = "ourzoo-root"
    key = "woznet/ec2-in-default-vpc/eu-west-2.tfstate"
    acl = "bucket-owner-full-control"
  }
}
