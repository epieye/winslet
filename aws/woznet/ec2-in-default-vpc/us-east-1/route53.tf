resource "aws_route53_record" "amos" {
  zone_id = "Z07643963KV3I332WTGCB"
  name    = "amos.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.default_bastion.public_ip]
}
