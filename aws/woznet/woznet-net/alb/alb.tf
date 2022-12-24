# change to alb
# change to https
# add more zones

resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
    #aws_security_group.elb_http.id
    aws_security_group.allow_http.id
  ]
  subnets = [
    #aws_subnet.public_us_east_1a.id,       # vanuatu private
    #aws_subnet.public_us_east_1b.id
    #module.vanuatu.public_us_east_1a.id,
    #module.vanuatu.public_us_east_1b.id
    module.vanuatu.public_subnet_ids[0],
    module.vanuatu.public_subnet_ids[1]
  ]

  cross_zone_load_balancing   = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }

}




output "elb_dns_name" {
  value = aws_elb.web_elb.dns_name
}
