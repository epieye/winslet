# S3 bucket for website. 

resource "aws_s3_bucket" "www_bucket" {
  bucket = var.name
}







resource "aws_s3_bucket_acl" "www_bucket" {
  bucket = aws_s3_bucket.www_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "www_bucket" {
  bucket = aws_s3_bucket.www_bucket.bucket

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.kinaida.net"] # ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_website_configuration" "www_bucket" {
  bucket = aws_s3_bucket.www_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  #error_document {
  #  key = "error.html"
  #}
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.www_bucket.id
  policy = templatefile("iam/s3-policy.json", { bucket = "www.kinaida.net" })
}

#resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
#  bucket = aws_s3_bucket.this.id
#
#  rule {
#    apply_server_side_encryption_by_default {
#      kms_master_key_id = data.aws_kms_key.s3.arn
#      sse_algorithm     = "aws:kms"
#    }
#  }
#}

#  "website_domain" = "s3-website-us-east-1.amazonaws.com"
#  "website_endpoint" = "www.kinaida.net.s3-website-us-east-1.amazonaws.com"
#resource "aws_route53_record" "www_kinaida" {
#  zone_id      = ""
#  name         = "www.kinaida.net"
#  type         = "CNAME"
#  ttl          = "300"
#  records      = aws_s3_bucket.www_bucket.website_domain
#}

#output "www_bucket" {
#  value = aws_s3_bucket.www_bucket
#}
