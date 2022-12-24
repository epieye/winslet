# route 53
#  "website_domain" = "s3-website-us-east-1.amazonaws.com"
#  "website_endpoint" = "www.kinaida.net.s3-website-us-east-1.amazonaws.com"
#resource "aws_route53_record" "www_kinaida" {
#  zone_id      = ""
#  name         = "www.kinaida.net"
#  type         = "CNAME"
#  ttl          = "300"
#  records      = aws_s3_bucket.www_bucket.website_domain
#}
