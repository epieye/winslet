//bucket must be previously created.

#us-east-1 Virgina
#us-east-2 Ohio
#us-west-2 Oregon
#eu-north-1 Stockholm
#eu-west-2 London
#ap-southeast-2 Sydney
# should I make a tfvar and use var.region? Would it tear down the other region if I just updated the vars file?

terraform {
  backend "s3" {
    bucket = "ourzoo.us"
    region = "us-east-1"
    profile = "ourzoo-root"
    key = "woznet/transit-gateway-routing.tfstate"
    acl = "bucket-owner-full-control"
  }
}
