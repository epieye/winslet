# Can only use an ENI once.
# also add filters.
# do I need to modify SG too? Allow UDP/4789. Check first if intra-VPC traffic is allowed. 

#resource "aws_ec2_traffic_mirror_filter" "filter" {
#  description      = "traffic mirror filter - terraform example"
#  network_services = ["amazon-dns"]
#}

##Inbound and Outbound: check first if no rule mirrors all traffic.
##100 accept All Protocols 0.0.0.0/0 0.0.0.0/0 

#resource "aws_ec2_traffic_mirror_target" "target" {
#  #network_load_balancer_arn = aws_lb.lb.arn
#  network_interface_id = module.default_bastion.module_ec2.primary_network_interface_id
#}

#resource "aws_ec2_traffic_mirror_session" "session" {
#  description              = "traffic mirror session - terraform example"
#  #network_interface_id     = aws_instance.test.primary_network_interface_id
#  network_interface_id     = module.secondary_server.module_ec2.primary_network_interface_id
#  session_number           = 2
#  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
#  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.target.id
#}

