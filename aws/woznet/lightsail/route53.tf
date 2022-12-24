resource "aws_route53_record" "network-test-dev" {
  zone_id      = "Z07643963KV3I332WTGCB"
  name         = "network-test-dev.kinaida.net"
  type         = "A"
  ttl          = "300"
  records      = [aws_lightsail_instance.https_server.public_ip_address]
}

resource "aws_route53_record" "onetimesecret" {
  zone_id      = "Z07643963KV3I332WTGCB"
  name         = "ots.kinaida.net"
  type         = "A"
  ttl          = "300"
  records      = [aws_lightsail_instance.https_server.public_ip_address]
}
