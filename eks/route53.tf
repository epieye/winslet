resource "aws_route53_record" "www" {
 zone_id = "Z07643963KV3I332WTGCB"
  name    = "www.kinaida.net"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_eks_cluster.ourzoo.endpoint]
}
