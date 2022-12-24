#module "default_sg" {
#  source = "../../../modules/security_group"
#
#  vpc_id = "vpc-cb7a34ae" # Default VPC
#
#  # If I remove the ingress rules, will it create an entirely closed default sg?
#  # No. Ingress is required. tags are required too.
#  # Although this isn't the same as Roy's; he's got resource default_sg. Try that instead.
#  # Cool. This creates a security group, doesn't amend the default security group. 
#  # Roy is right, aws_default_security_group with no ingress or egress creates a closed default security group.
#  # try it in woznet. Close the default security group and create a dedicated one. 
#  ingress = [
#    {
#      from_port  = 22
#      to_port = 22
#      protocol = "tcp"
#      cidr_blocks = ["0.0.0.0/0"]
#    }
#  ]
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "default-vpc-ssh-access"
#    }
#  )
#}
#
## close the default sg and create a dedicated one.
##resource "aws_default_security_group" "default" {
##  vpc_id = "vpc-cb7a34ae"
##}
