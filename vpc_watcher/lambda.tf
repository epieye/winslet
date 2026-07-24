####################################################################################
#                                                                                  #
# zip -r ../vpc_watcher.zip .                                                      #
# aws s3 cp vpc_watcher.zip s3://ourzoo.us/ --profile OurzooAWSAdministratorAccess #
# aws lambda update-function-code --function-name vpc_event_watcher --zip-file fileb://vpc_watcher.zip --profile OurzooAWSAdministratorAccess --region us-east-1
#                                                                                  #
####################################################################################

resource "aws_lambda_function" "vpc_event_watcher" {
  function_name = "vpc_event_watcher"
  s3_bucket     = "ourzoo.us"
  s3_key        = "vpc_watcher.zip"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.vpc_event_watcher_role.arn
  timeout       = 30
  memory_size   = 128
}

