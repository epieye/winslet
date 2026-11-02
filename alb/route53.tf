resource "aws_route53_record" "web_server" {
 zone_id = "Z07643963KV3I332WTGCB"
  name    = "www.kinaida.net"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.woznet_alb.dns_name]
}

resource "aws_route53_record" "vanity_url" {
 zone_id = "Z07643963KV3I332WTGCB"
  name    = "ginseng.kinaida.net"  # mimic a vanity URL. 
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.woznet_alb.dns_name]
}

