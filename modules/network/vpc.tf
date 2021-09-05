/* 
   I don't know we need half of this. Just a public address to get to the EC2. Use the default vpc and see.
*/

data "aws_availability_zones" "azs" {
  
  filter {
    name   = "zone-id"
    values = var.custom_az_ids
  }
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.base_cidr_block
  assign_generated_ipv6_cidr_block = true
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = var.tags
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.vpc.id
  count                   = var.private_subnet_count
  cidr_block              = cidrsubnet(var.base_cidr_block, var.private_subnet_count, count.index)
  availability_zone       = element(data.aws_availability_zones.azs.names, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Name"]}-sub-private-${data.aws_availability_zones.azs.names[count.index]}-${count.index}"
    }
  )
}

## K8S Tags
## "kubernetes.io/role/internal-elb" = 1
## "kubernetes.io/role/elb" = 1
## "kubernetes.io/cluster/${var.tags["Name"]}" = "shared"

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.vpc.id
  count                   = var.internet_gateway || var.nat_gateway ? 2 : 0
  cidr_block              = cidrsubnet(var.base_cidr_block, 2, tonumber(count.index) + 2)
  availability_zone       = element(data.aws_availability_zones.azs.names, count.index)

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Name"]}-sub-public-${data.aws_availability_zones.azs.names[count.index]}-${count.index}"
    }
  )
}

resource "aws_eip" "nat_gateway" {
  count    = var.nat_gateway ? var.private_subnet_count : 0
  vpc      = true
  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Name"]}-eip-${data.aws_availability_zones.azs.names[count.index]}-${count.index}"
    }
  )
}

resource "aws_nat_gateway" "gw" {
  count    = var.nat_gateway ? 2 : 0
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  
  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Name"]}-ngw-${data.aws_availability_zones.azs.names[count.index]}-${count.index}"
    }
  )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  
  lifecycle {
    ignore_changes = [
      route,
    ]
  }
  
  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Name"]}-rtb-1"
    }
  )
}

resource "aws_route_table" "public_route_table" {
  count = var.internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  
  lifecycle {
    ignore_changes = [
      route,
    ]
  }
  
  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Name"]}-rtb-2"
    }
  )
}


resource "aws_route" "custom_private_routes" {
  count = length(var.custom_private_routes) > 0 ? length(var.custom_private_routes) : 0 
  route_table_id            = aws_route_table.private_route_table.id 
  destination_cidr_block         = lookup(var.custom_private_routes[count.index], "destination_cidr_block", null)
  transit_gateway_id  = lookup(var.custom_private_routes[count.index], "transit_gateway_id", null)
  depends_on = [aws_route_table.private_route_table]
}

resource "aws_route" "custom_public_routes" {
  count = length(var.custom_public_routes) > 0 ? length(var.custom_public_routes) : 0
  route_table_id            = aws_route_table.public_route_table[0].id
  destination_cidr_block         = lookup(var.custom_public_routes[count.index], "destination_cidr_block", null)
  transit_gateway_id  = lookup(var.custom_public_routes[count.index], "transit_gateway_id", null)
  depends_on = [aws_route_table.public_route_table[0]]
}


resource "aws_route_table_association" "private" {
  count          = length(data.aws_availability_zones.azs.names)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "public" {
  count          = var.internet_gateway ? 2 : 0
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_route_table[0].id
  depends_on = [aws_route_table.public_route_table[0]]
}


resource "aws_internet_gateway" "igw" {
  count  = var.internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Name"]}-igw-1"
    }
  )
}

// This is what I want, but terraform isn't adding the route. 
// Or is it? I just have the one route table eh?
// a-ha! Why do I have rtb-1 and rtb-2 ? the second one has the igw, but it is unused. apparently.
// rtb-1 -> private?
// rtb-2 -> public?

resource "aws_route" "public_route_igw" {
  count  = var.internet_gateway ? 1 : 0
  route_table_id            = aws_route_table.public_route_table[0].id

  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw[0].id
  depends_on = [aws_route_table.public_route_table[0]]
}

resource "aws_route" "private_route_igw" {
  count    = var.nat_gateway ? 1 : 0
  route_table_id            = aws_route_table.private_route_table.id

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.gw[count.index].id
  depends_on = [aws_route_table.private_route_table]
}

resource "aws_security_group" "endpoint_sg" {
  count = length(var.endpoints) > 0 ? 1 : 0
  name        = "${var.tags["Name"]}-Endpoint-SG"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_vpc_endpoint" "endpoints" {
  count = length(var.endpoints)
  vpc_id            = aws_vpc.vpc.id
  service_name      = var.endpoints[count.index]
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.endpoint_sg[0].id,
  ]
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "cidr_block" {
  value = var.base_cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}
output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}

output "public_route_table_id" {
  value = aws_route_table.public_route_table.*.id
}

output "subnet_ids" {
  value = concat(aws_subnet.private_subnets[*].id, aws_subnet.public_subnets[*].id)
}

output "igw_id" {
  value = aws_internet_gateway.igw
}
