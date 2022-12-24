### "Now, we will use the module terraform-aws-modules/lambda/aws to create lambda and lambda layer infrastructure."
### where/how did you provision event bridge?
### - We can only create scheduled rules on the default event bus. So, you do not see any event bus creation in terraform script inside the blog.
##
##
##module "profile_generator_lambda" {
##  #source  = "terraform-aws-modules/lambda/aws"
##  source = "../../module/lambda/" # yeah so this isn't going to work.
##  
##  version = "2.7.0"
##  # insert the 28 required variables here
##  function_name = "profile-generator-lambda"
##  description   = "Generates a new profiles"
##  handler       = "index.handler"
##  runtime       = "nodejs14.x"
##  source_path   = "${path.module}/resources/profile-generator-lambda"
##
##  tags = {
##    Name = "profile-generator-lambda"
##  }
##}
#
#resource "aws_iam_role" "iam_for_lambda" {
#  name = "iam_for_lambda"
#
#  assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "lambda.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
#}
#EOF
#}
#
#resource "aws_lambda_function" "check_foo" {
#    filename = "lambdas/test.zip"
#    function_name = "checkFoo"
#    role = aws_iam_role.iam_for_lambda.arn
#    handler = "handler"
#    #source_code_hash = filebase64sha256("lambdas/test.zip")
#    runtime = "python3.9"
#}
#
###resource "aws_lambda_function" "scratchycoopark3" {
###  filename      = "lambdas/test.zip" # can't pass filename to source_code_hash. ffs.
###  function_name = "scratchycoopark3"
###  role          = aws_iam_role.iam_for_lambda.arn
###  handler       = "handler"
###
###  # The filebase64sha256() function is available in Terraform 0.11.12 and later
###  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
###  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
###  source_code_hash = filebase64sha256("lambdas/test.zip")
###
###  runtime = "python3.9"
###
###  environment {
###    variables = {
###      foo = "bar"
###    }
###  }
###}
#
#
#
#resource "aws_cloudwatch_event_rule" "every_five_minutes" {
#    name = "every-five-minutes"
#    description = "Fires every five minutes"
#    schedule_expression = "rate(5 minutes)"
#}
#
#resource "aws_cloudwatch_event_target" "check_foo_every_five_minutes" {
#    rule = "${aws_cloudwatch_event_rule.every_five_minutes.name}"
#    target_id = "check_foo"
#    arn = "${aws_lambda_function.check_foo.arn}"
#}
#
#resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
#    statement_id = "AllowExecutionFromCloudWatch"
#    action = "lambda:InvokeFunction"
#    function_name = "${aws_lambda_function.check_foo.function_name}"
#    principal = "events.amazonaws.com"
#    source_arn = "${aws_cloudwatch_event_rule.every_five_minutes.arn}"
#}
