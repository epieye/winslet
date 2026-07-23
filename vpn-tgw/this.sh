tp -target aws_vpc.woznet_vpc \
   -target aws_subnet.woznet_subnet_public_1a \
   -target aws_subnet.woznet_subnet_public_1b \
   -target aws_internet_gateway.woznet-igw \
   -target aws_eip.woznet-eip-a \
   -target aws_eip.woznet-eip-b \
   -target aws_nat_gateway.woznet-ngw-a \
   -target aws_nat_gateway.woznet-ngw-b

#tp -target aws_subnet.woznet_subnet_private_1a \
#   -target aws_subnet.woznet_subnet_private_1b \
#   -target aws_instance.chrisjen 

#tp -target aws_customer_gateway.ToOurzoo \
#   -target aws_vpn_connection.vpn_connection 

#tp -target aws_ec2_transit_gateway.woznet-tg \
#   -target aws_ec2_transit_gateway_route.custom_routes\[\"woznet1\"\] \
#   -target aws_ec2_transit_gateway_route.last_resort \
#   -target aws_ec2_transit_gateway_route_table.woznet \
#   -target aws_ec2_transit_gateway_route_table_association.associations\[\"woznet1\"\] \
#   -target aws_ec2_transit_gateway_vpc_attachment.woznet \
#   -target aws_route_table.woznet1a-private-crt \
#   -target aws_route_table_association.woznet_subnet_private_1a \
#   -target aws_security_group.woznet-sg 

