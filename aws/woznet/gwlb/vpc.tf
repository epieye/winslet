/*


*/

#192.168.12.0/22 gwlb
#- 192.168.12.0/24
#-- 192.168.12.0/26
#-- 192.168.12.64/26
#-- 192.168.12.128/26
#-- 192.168.12.192/26
#- 192.168.13.0/24
#- 192.168.14.0/24
#- 192.168.15.0/24

#Is it 3 VPCs
#or 3 subnets in 1 vpc?  <- start with 3 subnets in 1 VPC.
# I don't need a transit gateway for now.


module "woznet" {
  source = "../../modules/vpc"

  base_cidr_block = "192.168.12.0/24"
  internet_gateway = true
  private_subnet_count = 3

  # why is it creating so many subnets?

  tags = merge(
    module.configuration.tags,
    {
      Name = "woznet"
    }
  )
}
