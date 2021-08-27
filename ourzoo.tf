#/*
#   Ourzoo
#   Create VPCs and TGW for inter-VPC routing.
#*/
#
#module "ourzoo" {
#  source = "./modules/vpc"
#
#  base_cidr_block = "192.168.1.0/24"
#  internet_gateway = true
#
#  # don't forget we want 3 AZs for Kubernetes
#
#  custom_private_routes = [
#    {
#      destination_cidr_block = "192.168.0.0/16"
#      transit_gateway_id = module.transit_gateway.id
#    }
#  ]
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "ourzoo"
#    }
#  )
#}
#
#module "ourzoo_tgw_attachment" {
#  source = "./modules/transit_gateway_attachment"
#
#  subnet_ids = module.ourzoo.private_subnet_ids
#  vpc_id = module.ourzoo.vpc_id
#  transit_gateway_id = module.transit_gateway.id
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "Ourzoo-attach"
#    }
#  )
#}
#
##outputs
#
#output "ourzoo_tgw_attach_id" {
#  value = module.ourzoo_tgw_attachment.id
#}
#
#output "ourzoo_vpc_id" {
#  value = module.ourzoo.vpc_id
#}
#
