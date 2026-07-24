#output "private-ec2" {
#  value = aws_instance.ec2_private.private_ip
#}
#
#output "private2-ec2" {
#  value = aws_instance.ec2_private2.private_ip
#}


output "tg-rtb-id" {
  value = aws_ec2_transit_gateway_route_table.woznet-tg-rtb.id
} 
