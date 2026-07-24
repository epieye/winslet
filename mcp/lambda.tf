resource "aws_lambda_function" "mcp_server_function" {
  function_name = "mcp_server"
  s3_bucket     = "ourzoo.us"
  s3_key        = "mcp.zip"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 30
  memory_size   = 128

  environment {
    variables = {
      ACCOUNT             = ""
      ALB_NAME            = "mcp_server"
      TARGET_GROUP        = ""
      TARGET_ALB_DNS_NAME = ""
    }
  }
}



