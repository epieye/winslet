/*
   Ourzoo
   Create VPCs and TGW for inter-VPC routing.
*/

module "ourzoo" {
  source = "../modules/vpc"

  base_cidr_block = "192.168.1.0/24"
  internet_gateway = true

  # don't forget we want 3 AZs for Kubernetes

  #custom_private_routes = [
  #  {
  #    destination_cidr_block = "192.168.0.0/16"
  #    transit_gateway_id = module.transit_gateway.id
  #  }
  #]

  tags = merge(
    module.configuration.tags,
    {
      Name = "ourzoo"
    }
  )
}

#module "ourzoo_tgw_attachment" {
#  source = "../modules/transit_gateway_attachment"
#
#  subnet_ids = module.ourzoo.private_subnet_ids
#  vpc_id = module.ourzoo.vpc_id
#  #transit_gateway_id = module.transit_gateway.id
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "Ourzoo-attach"
#    }
#  )
#}

#module "ourzoo_sg" {
#  source = "../modules/security_group"
#
#  vpc_id = module.ourzoo.vpc_id
#
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
#      Name = "ourzoo-sg"
#    }
#  )
#}

#// Put ourzoo is zone-b for no good reason.
#module "ourzoo_ec2" {
#  source = "../modules/ec2_instance"
#
#  ami_id = data.aws_ami.amznix2.id
#  key_name  = "Monaco"
#  subnet_id = module.ourzoo.private_subnet_ids[1]
#  user_data = data.template_file.user_data.rendered
#  public_ip = true
#
#  vpc_sec_group = module.ourzoo_sg.id
#
#  tags = merge (
#    module.configuration.tags,
#    {
#      Name = "ourzoo_ec2"
#    }
#  )
#}

#outputs

#output "ourzoo_tgw_attach_id" {
#  value = module.ourzoo_tgw_attachment.id
#}
#
#output "ourzoo_vpc_id" {
#  value = module.ourzoo.vpc_id
#}

#output "ourzoo_public_address" {
#  value = module.ourzoo_ec2.public_ip
#}
