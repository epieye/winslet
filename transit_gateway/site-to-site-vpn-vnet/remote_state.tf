#data "terraform_remote_state" "azure" {
#  backend = "s3"
#  config = {
#    bucket  = "ourzoo.us"
#    region  = "us-east-1"
#    profile = "OurzooAWSAdministratorAccess"
#    key     = "woznet/azure_wan_hub.tfstate"
#    acl     = "bucket-owner-full-control"
#  }
#}

data "terraform_remote_state" "transit_gateway" {
  backend = "s3"
  config = {
    bucket  = "ourzoo.us"
    region  = "us-east-1"
    profile = "OurzooAWSAdministratorAccess"
    key     = "woznet/transit-gateway.tfstate"
    acl     = "bucket-owner-full-control"
  }
}

