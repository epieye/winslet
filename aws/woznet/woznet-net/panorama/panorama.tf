// Security Groups
module "datascan-panorama-sg" {
  source = "../../modules/security_group"

  #vpc_id = module.woznet.vpc_id 
  vpc_id = "vpc-042953058732f9aa3"

  // tighten to 22 and 443, possible from the workstation subnet.
  ingress = [
    {
      from_port  = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["192.168.0.0/16"]
    }
  ]

  tags = merge(
    module.configuration.tags,
    {
      Name = "Panorama-SG"
    }
  )
}

module "panorama" {
  source              = "../../modules/panorama/"
  #global_tags         = module.configuration.tags
  panoramas           = var.panoramas
  #panorama_version    = var.panorama_version
  #prefix_name_tag     = ""
  #subnets_map         = {"panorama-a": module.security_tooling_vpc_1.private_subnet_ids[0], "panorama-b": module.security_tooling_vpc_1.private_subnet_ids[1]}
  subnets_map         = {"panorama-a": "subnet-082b96b4c833c4b10", "panorama-b": "subnet-070bb53b623dd6678"}
  security_groups_map = {"datascan-panorama-sg": module.datascan-panorama-sg.id}
}

