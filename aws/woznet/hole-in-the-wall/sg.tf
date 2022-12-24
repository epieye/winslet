# Allow all ports so I can test 

module "hole_in_the_wall_sg" {
  source = "../../modules/security_group"

  vpc_id = module.hole_in_the_wall.vpc_id

  ingress = [
    {
      from_port  = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port  = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port  = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = merge(
    module.configuration.tags,
    {
      Name = "hole-in-the-wall-sg"
    }
  )
}
