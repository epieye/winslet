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

#output "tgw_id" {
#  value = aws_ec2_transit_gateway.woznet-tg.id
#}

# Used for s2s tunnel.
output "woznet1_vpc_id" {
  value = aws_vpc.woznet_vpc1.id
}

#output "woznet_vpc1_cidr_block" {
# value = aws_vpc.woznet_vpc1.cidr_block
#}
