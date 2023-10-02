######################################################################
#                                                                    #
# I probably do have to output something, for use in another folder. #
#                                                                    #
######################################################################

#data "aws_instances" "amos" {
#  filter {
#    name   = "tag:Name"
#    values = ["amos"]
#  }
#}

#output "amos_instance_id" {
#  value = data.aws_instances.amos.ids[0]
#}

#output "eip-a" {
#  value = aws_eip.woznet-eip-a.public_ip
#}

#output "eip-b" {
#  value = aws_eip.woznet-eip-b.public_ip
#}

# Use by Kinaida
output "tgw_id" {
  value = aws_ec2_transit_gateway.woznet-tg.id
}

# Used for s2s tunnel.
output "woznet1_vpc_id" {
  value = aws_vpc.woznet_vpc1.id
}

#output "woznet_vpc1_cidr_block" {
# value = aws_vpc.woznet_vpc1.cidr_block
#}

#output "woznet_vpc1" {
# value = aws_vpc.woznet_vpc1
#}

# Used for resolver
output "woznet_subnet_private_1a_id" {
  value = aws_subnet.woznet_subnet_private_1a.id
}

# Used for resolver
output "woznet_subnet_private_1b_id" {
  value = aws_subnet.woznet_subnet_private_1b.id
}

## Do I need all these?
#output "woznet_rt" {
#  value = aws_ec2_transit_gateway_route_table.woznet
#}

# Needed to add s2s tunnel to tgw routing table once the tunnel is created in ./site-to-site-vpn
output "tgw_rtb_id" {
  value = aws_ec2_transit_gateway_route_table.woznet.id
}

# internal zone id. Needed for Azure VMs (cotyar and clarissa)
output "internal_zone_id" {
  value = aws_route53_zone.internal.zone_id
}


