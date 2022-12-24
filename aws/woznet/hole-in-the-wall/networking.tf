module "hole_in_the_wall" {
  source = "../../modules/vpc"

  base_cidr_block = "192.168.10.0/24"
  internet_gateway = true

  tags= merge(
    module.configuration.tags,
    {
      Name = "woznet"
    }
  )
}

# vpce so lambda runs inside the VPC
# no this is to access services
# actually maybe I don't need this.


## create a VPC endpoint so the lambda in my VPC can connect to secrets manager / sqs
#resource "aws_vpc_endpoint" "sqs_service" {
#  vpc_id            = module.hole_in_the_wall.vpc_id
#  service_name      = "com.amazonaws.us-east-1.sqs"
#  vpc_endpoint_type = "Interface"
#
#  subnet_ids        = [
#    module.hole_in_the_wall.public_subnet_ids[0],
#    module.hole_in_the_wall.public_subnet_ids[1]
#  ]
#
#  security_group_ids = [
#    module.hole_in_the_wall_sg.id
#  ]
#
#  private_dns_enabled = true
#}

#resource "aws_vpc_endpoint" "secret_service" {
#  vpc_id            = module.hole_in_the_wall.vpc_id
#  service_name      = "com.amazonaws.us-east-1.secretsmanager"
#  vpc_endpoint_type = "Interface"
#
#  subnet_ids        = [
#    module.hole_in_the_wall.public_subnet_ids[0],
#    module.hole_in_the_wall.public_subnet_ids[1]
#  ]
#
#  security_group_ids = [
#    module.hole_in_the_wall_sg.id
#  ]
#
#  private_dns_enabled = true
#}

output "hole_in_the_wall_settings" {
  value = module.hole_in_the_wall
}

