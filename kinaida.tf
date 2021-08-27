#/*
#   Kinaida
#   Create VPCs and TGW for inter-VPC routing.
#*/
#
#module "kinaida" {
#  source = "./modules/vpc"
#
#  base_cidr_block = "192.168.2.0/24"
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
#      Name = "kinaida"
#    }
#  )
#}
#
#module "kinaida_tgw_attachment" {
#  source = "./modules/transit_gateway_attachment"
#
#  subnet_ids = module.kinaida.private_subnet_ids
#  vpc_id = module.kinaida.vpc_id
#  transit_gateway_id = module.transit_gateway.id
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "Kinaida-attach"
#    }
#  )
#}
#
##outputs
#
#output "kindaida_tgw_attach_id" {
#  value = module.kinaida_tgw_attachment.id
#}
#
#output "kinaida_vpc_id" {
#  value = module.woznet.vpc_id
#}
#
