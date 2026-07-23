

resource "aws_vpc_endpoint_service" "gwlb_endpoint_service" {
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gateway_lb.arn]
  tags = {
    Name = "woznet-eps-gwlb"
  }
}

resource "aws_vpc_endpoint" "gwlb_endpoint_a" {
  service_name      = aws_vpc_endpoint_service.gwlb_endpoint_service.service_name
  subnet_ids        = [aws_subnet.      .id]
  vpc_endpoint_type = aws_vpc_endpoint_service.gwlb_endpoint_service.service_type
  vpc_id            = aws_vpc.woznet-egress-vpc.id
  tags = {
    Name = "woznet-eps-gwlb-a"
  }
}

resource "aws_vpc_endpoint" "gwlb_endpoint_b" {
  service_name      = aws_vpc_endpoint_service.gwlb_endpoint_service.service_name
  subnet_ids        = [aws_subnet.      .id]
  vpc_endpoint_type = aws_vpc_endpoint_service.gwlb_endpoint_service.service_type
  vpc_id            = aws_vpc.woznet-egress-vpc.id
  tags = {
    Name = "woznet-eps-gwlb-b"
  }
}
