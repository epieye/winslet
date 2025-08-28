resource "aws_route53_record" "web_server" {
 zone_id = "Z07643963KV3I332WTGCB"
  name    = "www.kinaida.net" # How do I add kinaida.net too?
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.woznet_alb.dns_name]
}

