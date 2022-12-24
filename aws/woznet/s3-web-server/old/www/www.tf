resource "aws_s3_bucket_cors_configuration" "www_bucket" {
  bucket = "network-test-dev.kinaida.net"

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET"]
    #allowed_origins = ["https://network-test-dev.kinaida.net"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_website_configuration" "www_bucket" {
  bucket = "network-test-dev.kinaida.net"

  index_document {
    suffix = "index.html"
  }
}

output "aws_s3_bucket_website_configuration" {
  value = aws_s3_bucket_website_configuration.www_bucket.website_endpoint
}
