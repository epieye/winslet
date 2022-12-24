data "terraform_remote_state" "woznet" {
  backend = "s3"
  config = {
    bucket = "ourzoo.us"
    region = "us-east-1"
    key = "woznet.tfstate"
    #profile = "ourzoo-root"
    profile = "default"
    acl = "bucket-owner-full-control"
  }
}

data "terraform_remote_state" "woznet-lambda" {
  backend = "s3"
  config = {
    bucket = "ourzoo.us"
    region = "us-east-1"
    key = "woznet-lambda.tfstate"
    #profile = "ourzoo-root"
    profile = "default"
    acl = "bucket-owner-full-control"
  }
}

#data "terraform_remote_state" "ourzoo" {
#  backend = "s3"
#  config = {
#    bucket = "ourzoo.us"
#    region = "us-east-1"
#    key = "ourzoo.tfstate"
#    profile = "ourzoo-us"
#    acl = "bucket-owner-full-control"
#  }
#}

#//bucket must be previously created.
#terraform {
#  backend "s3" {
#    bucket = "ourzoo.us"
#    region = "us-east-1"
#    profile = "ourzoo-root"
#    key = "woznet.tfstate"
#    acl = "bucket-owner-full-control"
#  }
#}

#data "terraform_remote_state" "kinaida" {
#  backend = "s3"
#  config = {
#    bucket = "kinaida.net"
#    region = "us-east-1"
#    key = "terraform.tfstate"
#    profile = "kinaida-root"
#    acl = "bucket-owner-full-control"
#  }
#}
