resource "aws_s3_bucket_cors_configuration" "www_bucket" {
  bucket = "network-test-dev.kinaida.net"

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://network-test-dev.kinaida.net"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_website_configuration" "www_bucket" {
  bucket = "network-test-dev.kinaida.net"

  index_document {
    suffix = "index.html"
  }
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.www_bucket.website_endpoint
}





# Custom SSL certificate
# route 53
# 



#So after all that, basically I can't do it. No https.


#Amazon S3 website endpoints do not support HTTPS or access points. 
#If you want to use HTTPS, you can use Amazon CloudFront to serve a static website hosted on Amazon S3.


