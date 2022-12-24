## https://registry.terraform.io/modules/aws-ia/ipam/aws/latest
## Description for IPAM instead of IPAM with primary in us-east-1
## ipam-0650a312aa843d831 - winslet
## ipam-06980e9f74ab8805e - bespin 
## I won't need two in prod.
#
##module "built-in" {
##  source  = "aws-ia/ipam/aws"
##  version = "1.0.0"
##
##  top_description = "DefaultVPC"
##  top_cidr = ["172.31.0.0/16"]
##  ipam_scope_type = "private"
##}
#
#module "bespin" {
#  source  = "aws-ia/ipam/aws"
#  version = "1.0.0"
#
#  top_description = "Bespin"
#  top_cidr = ["10.240.0.0/12"]
#  ipam_scope_type = "private"
#
#  pool_configurations = {
#    devqa = {
#      description = "Development and QA"
#      cidr = ["10.245.0.0/16"]
#
#      sub_pools = {
#        # CORE-AWS-AUDIT
#        # CORE-AWS-LOGGING
#        Network-shared-infrastructure = { cidr = ["10.245.0.0/20"] },
#        Security-tooling              = { cidr = ["10.245.16.0/20"] },
#        #SECURITY-BREAK-GLASS
#        DEVQA-SHARED-INFRA            = { cidr = ["10.245.32.0/20"] },
#        DEV-QA                        = { cidr = ["10.245.48.0/20"] },
#        Devqa-wi-FSx-subnet           = { cidr = ["10.245.64.0/25"] },
#        uat-wi-FSx-subnet             = { cidr = ["10.245.64.128/25"] },
#        Lab-perf-FSx-Subnet           = { cidr = ["10.245.65.0/25"] },
#        Prod-Wi-FSx-Subnet            = { cidr = ["10.245.65.128/25"] },
#        # (scalability/ growth) 10.245.66.128/25
#        # (scalability/ growth) 10.245.67.0/24
#        # (scalability/ growth) 10.245.68.0/22
#        # (scalability/ growth) 10.245.72.0/21
#        Lab-Qual-FSx-Subnet           = { cidr = ["10.245.66.0/25"] },
#        DEV-QA-DATATCISION            = { cidr = ["10.245.80.0/20"] },
#        DevQA-Common-SaaS             = { cidr = ["10.245.96.0/20"] },
#        DevQA-IRM                     = { cidr = ["10.245.112.0/20"] },
#        DST-Associate-VPN             = { cidr = ["10.245.128.0/22"], description = "provider managed" },
#        # (scalability/ growth)	10.245.132.0/22
#        # (scalability/ growth) 10.245.136.0/21
#        DataEngineering-Lake          = { cidr = ["10.245.144.0/20"] }
#        #(scalability/ growth)	10.245.160.0/19
#        #(scalability/ growth)  10.245.192.0/18
#      }
#    },
#    uat = {
#      description = "UAT and PREPROD"
#      cidr = ["10.247.0.0/16"]
#
#      sub_pools = {
#        LAB-ENGINEERING	  = { cidr = ["10.247.0.0/20"] },
#        LAB-PERFORMANCE	  = { cidr = ["10.247.16.0/20"] },
#        LAB-QUALIFICATION = { cidr = ["10.247.32.0/20"] },
#        STAGING-LAKE      = { cidr = ["10.247.48.0/20"], description = "Was Lab-Yonah" },
#        UAT-IRM           = { cidr = ["10.247.64.0/20"] },
#        UAT-AI            = { cidr = ["10.247.80.0/20"] },
#        UAT-DATACISION    = { cidr = ["10.247.96.0/20"] },
#        LAB-QUALIFICATION = { cidr = ["10.247.112.0/20"] },
#        UAT-WI            = { cidr = ["10.247.128.0/18"] },
#        # (scalability/ growth)	10.247.192.0 - 10.247.255.255
#
#      }
#    },
#    prod = {
#      description = "Production"
#      cidr = ["10.249.0.0/16"]
#
#      sub_pools = {
#        PROD-SHARED-INFRA = {
#          description = "Prod Shared Infra"
#          cidr = ["10.249.0.0/20"]
#          sub_pools = {
#            workspaces = { 
#              description = "Workspaces"         # priv workspaces
#              cidr = ["10.249.6.0/23"] 
#            },
#            masked = {
#              description = "Masked Workspaces"  # Is this right?
#              cidr = ["10.249.12.0/23"]          # Is this right?
#            }
#          }
#        },
#        # I can I have sub-sub workspaces?
#        #(scalability/ growth) 10.249.16.0/20
#        PROD-AI           = { cidr = ["10.249.32.0/20"] },
#        PROD-DATACISION   = { cidr = ["10.249.48.0/20"] },
#        PROD-DATA-LAKE    = { cidr = ["10.249.64.0/20"] },
#        # (scalability/ growth) 10.249.80.0/20"] },
#        # (scalability/ growth) 10.249.96.0/19"] },
#        PROD-WI           = { cidr = ["10.249.128.0/18"] }
#        # (scalability/ growth)	10.249.192.0/18
#      }
#    }
#  }
#}
#
## Is there a better way to refer to the subnet other than remote_state?
#output "ipam" {
#  value = module.winslet        # .pool_configurations.woznet.cidr # .vpc_cidr_block
#}
