
# No associations for the main routing table. 

#ingress, egress - each has a public and a private routing table. 

#inspection
# public - the two public subnet
# mgmt a and b - 10.245.8.0/22->local; 0.0.0.0/0->tgw / b is identical. So why separate routing tables?
# gwlb a and b - 10.245.8.0/22->local; 0.0.0.0/0->tgw                   I dont see that I need separate tables. But lets try is and see what happens.
# tgw  a and b - 10.245.8.0/22->local; 0.0.0.0/0->vpce vpce-028b338d20f896a59 this makes sense. different vpce in each subnet.

# in the case of only two vpcs.
#ingress public - the public subnets habe default gatewy to the igw, and 10.245.8.0/22->local

#ingress private local only. - 
#egress/inspection public
#egress/inspection private



#gwlb-a                                                              10.245.9.0/25    
#gwlb-b                                                              10.245.9.128/25 .9 palo-data-a .116 gwlb .118 gwlb-e .142 .152 .164 palo-data-b 
#tgwa-a and the other is for regular traffic. Does that even make sense? the VPCe is the interface of the Palo Alto devices. 
#tgwa-b                                                              10.245.8.0/25, 10.245.8.128/25 .13 and .226 tgwa (so the name does mean something)
#
#mgmt-a                                                              10.245.10.0/25
#mgmt-b                                                              10.245.10.128/25


#public subnets are 10.245.11.0/25 and 10.245.11.128/25 for egress through the Palos/NAT instances. 
#The local route is 10.245.8.0/22

# so try it with just two subnets 
# and 

leave this so I remember to delete the notes. 


resource "aws_route_table" "      " {
  vpc_id = aws_vpc.woznet_ingress_vpc.id
  tags = {
    Name = "woznet-rtb-      "
  }
}

resource "aws_route" "              " {
  route_table_id         = aws_route_table.tgwa_a.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.               .id
  depends_on             = [aws_route_table.      ]
}
resource "aws_route_table_association" "    _rtb_association_a" {
  subnet_id      = aws_subnet.tgwa_a.id
  route_table_id = aws_route_table.tgwa_a.id
}

