# Look up the current AWS region dynamically
data "aws_region" "current" {}

# S3 Gateway VPC Endpoint Resource
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.woznet_vpc.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"

  # Automatically attaches the S3 routing to these route tables
  route_table_ids   = [
    aws_route_table.woznet1a-private-rtb.id,
    aws_route_table.woznet1b-private-rtb.id
  ]

  tags = {
    Name        = "s3-gateway-endpoint"
    Environment = "production"
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3_a_association" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.woznet1a-private-rtb.id
}

resource "aws_vpc_endpoint_route_table_association" "s3_b_association" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.woznet1b-private-rtb.id
}



