# Just additional subnets for EKS. Additional from standard set up in networking.tf

resource "aws_subnet" "woznet_subnet_public_1c" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "192.168.12.64/27"
  availability_zone = "us-east-1c"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "woznet-subnet-public-1c"
  }
}

resource "aws_subnet" "woznet_subnet_private_1c" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "192.168.12.192/27"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet1-subnet-private-1c"
  }
}

resource "aws_eip" "woznet-eip-c" {
  public_ipv4_pool = "amazon"

  tags = {
    "Name": "woznet-eip-c"
  }
}

resource "aws_nat_gateway" "woznet-ngw-c" {
  allocation_id = aws_eip.woznet-eip-c.id
  subnet_id = aws_subnet.woznet_subnet_public_1c.id

  tags = {
    Name = "woznet-ngw-c"
  }

  depends_on = [aws_internet_gateway.woznet-igw]
}

resource "aws_route_table_association" "woznet_subnet_public_1c" {
  subnet_id = aws_subnet.woznet_subnet_public_1c.id
  route_table_id = aws_route_table.woznet-rtb.id
}

resource "aws_route_table" "woznet1c-private-rtb" {
  vpc_id = aws_vpc.woznet_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.woznet-ngw-c.id
  }

  tags = {
    Name = "woznet1c-private-rtb"
  }
}

resource "aws_route_table_association" "woznet_subnet_private_1c" {
  subnet_id = aws_subnet.woznet_subnet_private_1c.id
  route_table_id = aws_route_table.woznet1c-private-rtb.id
}

