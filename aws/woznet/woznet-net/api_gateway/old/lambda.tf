#terraform {
#  required_providers {
#    aws = {
#      source = "hashicorp/aws"
#    }
#  }
#}
#
#provider "aws" {
#   region = "us-east-1"
#}

resource "aws_lambda_function" "examplepy" {
   function_name = "lambda_function"

   # The S3 bucket should already exists
   s3_bucket = "www.ourzoo.us"
   s3_key    = "v${var.app_version}/lambda_function.zip"

   # "lambda_function" is the filename within the zip file (lambda_function.py) 
   # and "handler" is the name of the property 
   # under which the handler function was exported in that file.
   handler = "lambda_function.lambda_handler"
   runtime = "python3.9"

   role = aws_iam_role.lambda_execpy.arn
}

 # IAM role which dictates what other AWS services the Lambda function may access.
resource "aws_iam_role" "lambda_execpy" {
   name = "serverless_example_lambdapy"

   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.examplepy.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}
