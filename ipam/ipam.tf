# https://registry.terraform.io/modules/aws-ia/ipam/aws/latest
# Description for IPAM instead of IPAM with primary in us-east-1
# ipam-0650a312aa843d831 - winslet
# ipam-06980e9f74ab8805e - bespin 
# I won't need two in prod.

#module "built-in" {
#  source  = "aws-ia/ipam/aws"
#  version = "1.0.0"
#
#  top_description = "DefaultVPC"
#  top_cidr = ["172.31.0.0/16"]
#  ipam_scope_type = "private"
#}

module "winslet" {
  source  = "aws-ia/ipam/aws"
  #version = "1.0.0"

  top_description = "Winslet"
  top_cidr = ["10.0.0.0/16"]
  ipam_scope_type = "private"

  pool_configurations = {
    woznet = {
      description           = "woznet top level pool"
      cidr                  = ["192.168.0.0/18"]
      publicly_advertisable = false

      sub_pools = {
        chatops = { cidr = ["192.168.0.0/24"] },
        #ec2-in-default-vpc = { cidr = ["192.168.1.0/24"] },   <- next: how do I tell the vpc that it is managed by ipam?
        eventbridge = { cidr = ["192.168.2.0/24"] },
        load-balancer = { cidr = ["192.168.3.0/24"] },
        serverless-db = { cidr = ["192.168.4.0/24"] },
        sqs-test = { cidr = ["192.168.5.0/24"] },
        hole-in-the-wall = { cidr = ["192.168.6.0/24"] },
        scarface = { cidr = ["192.168.7.0/24"] },
        woznet-net = { cidr = ["192.168.8.0/22"] },
        gwlb = { 
          cidr = ["192.168.12.0/22"] 
          sub_pools = {
            julian = {
              cidr = ["192.168.12.0/24"]
            },
            dick = {
              cidr = ["192.168.13.0/24"]
            },
            anne = {
              cidr = ["192.168.14.0/24"]
            },
            george = {
              cidr = ["192.168.15.0/25"]
            },
            timmy = {
              cidr = ["192.168.16.0/22"]
            }
          }
        }
      }
    },
    kinaida = {
      description      = "kinaida top level pool"
      cidr             = ["192.168.64.0/18"]
      publicly_advertisable = false
    },
    ourzoo = {
      description      = "ourzoo top level pool"
      cidr             = ["192.168.128.0/18"]
      publicly_advertisable = false
    },
    growth = {
      description      = "room for one more"
      cidr             = ["192.168.192.0/18"]
      publicly_advertisable = false
    }
  }
}
