#module "chatops" {
#  source = "../modules/vpc"
#
#  base_cidr_block = "192.168.0.0/24"
#  internet_gateway = true
#
#  tags= merge(
#    module.configuration.tags,
#    {
#      Name = "woznet"
#    }
#  )
#}
#
##output "chatops_settings" {
##  value = module.chatops
##}
#
