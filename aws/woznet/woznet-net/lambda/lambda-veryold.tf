
# Even though some of this worked to create the lambda function, I couldn't figure out the trigger
# try again with the tutorial code


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
### was test_lambda
##resource "aws_lambda_function" "scratchycoopark3" {
##  filename      = "lambdas/test.zip" # can't pass filename to source_code_hash. ffs.
##  function_name = "scratchycoopark3"
##  role          = aws_iam_role.iam_for_lambda.arn
##  handler       = "handler"
##
##  # The filebase64sha256() function is available in Terraform 0.11.12 and later
##  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
##  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
##  source_code_hash = filebase64sha256("lambdas/test.zip")
##
##  runtime = "python3.9"
##
##  environment {
##    variables = {
##      foo = "bar"
##    }
##  }
##}
#
### I guess I still don't get resource vs module. Can I just make resource "aws_lambda_function" "scratchycoopark3" to a module?
### I'm sure I at least need to define a source
### apparently not. A whole bunch of errors. How does the tutorial do it?
##module "scratchycoopark3" {
##  source = "../../modules/lambda"
##  filename      = "lambdas/test.zip" # can't pass filename to source_code_hash. ffs.
##  function_name = "scratchycoopark3"
##  role          = aws_iam_role.iam_for_lambda.arn
##  handler       = "handler"
##
##  # The filebase64sha256() function is available in Terraform 0.11.12 and later
##  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
##  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
##  source_code_hash = filebase64sha256("lambdas/test.zip")
##
##  runtime = "python3.9"
##
##  environment {
##    variables = {
##      foo = "bar"
##    }
##  }
##}
#
## tutorial code for profile_generator_lambda
#
#module "scratchycoopark3" {
#  source  = "../../modules/lambda"
#  #version = "2.7.0"
#  ## insert the 28 required variables here    <- ??
#  #function_name = "profile-generator-lambda"
#  #description   = "Generates a new profiles"
#  #handler       = "index.handler"
#  #runtime       = "nodejs14.x"
#  #source_path   = "${path.module}/resources/profile-generator-lambda"
#  #
#  #tags = {
#  #  Name = "profile-generator-lambda"
#  #}
#
#  #filename      = "lambdas/test.zip" # can't pass filename to source_code_hash. ffs.
#  #function_name = "scratchycoopark3"
#  #role          = aws_iam_role.iam_for_lambda.arn
#  handler       = "handler"
#  #source_code_hash = filebase64sha256("lambdas/test.zip")
#  runtime = "python3.9"
#  lambda_source_dir = "lambdas/test.zip"
#
#  tags = {
#    Name = "profile-generator-lambda"
#  }
#}
#
#
#
#
### call it champion instead of trigger
### event_source_arn is not optional other than one of event_source_arn or self_managed_event_source must be specified.
##resource "aws_lambda_event_source_mapping" "example" {
##  event_source_arn  = aws_dynamodb_table.example.stream_arn
##  function_name     = aws_lambda_function.test_lambda.arn
##}
### starting_position = "LATEST"
#
## set it to run every (say) 5 minutes to start with.
## I want to do this anyway, a la cron, e.g. key rotation every 60 days
## profile_generator_lambda is my scratchycoopark3
## But I have a resource not a module.
## should aws_cloudwatch_event_rule now be eventbridge?
#resource "aws_cloudwatch_event_rule" "scratchycoopark3_event_rule" {
#  name = "scratchycoopark3-event-rule"
#  description = "retry scheduled every 2 min"
#  schedule_expression = "rate(2 minutes)"
#}
#
## where is the rule set? - above. lol. Need a filter?
## arn was module but I only have a resource. made it a module now.
#resource "aws_cloudwatch_event_target" "scratchycoopark3_target" {
#  arn = module.scratchycoopark3.lambda_function_arn
#  rule = aws_cloudwatch_event_rule.scratchycoopark3_event_rule.name
#}
#
## function_name was module but I only have a resource. made it a module now.
#resource "aws_lambda_permission" "allow_cloudwatch_to_call_rw_fallout_retry_step_deletion_lambda" {
#  statement_id = "AllowExecutionFromCloudWatch"
#  action = "lambda:InvokeFunction"
#  function_name = module.scratchycoopark3.lambda_function_name
#  principal = "events.amazonaws.com"
#  source_arn = aws_cloudwatch_event_rule.scratchycoopark3_event_rule.arn
#}
#
#
#
#
#
## WTF is the rest of this shit?
#
##resource "aws_lambda_layer_version" "example" {
##  # ... other configuration ...
##}
##
##resource "aws_lambda_function" "example" {
##  # ... other configuration ...
##  layers = [aws_lambda_layer_version.example.arn]
##}
##
## A lambda function connected to an EFS file system
##resource "aws_lambda_function" "example" {
##  # ... other configuration ...
##
##  file_system_config {
##    # EFS file system access point ARN
##    arn = aws_efs_access_point.access_point_for_lambda.arn
##
##    # Local mount path inside the lambda function. Must start with '/mnt/'.
##    local_mount_path = "/mnt/efs"
##  }
##
##  vpc_config {
##    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
##    subnet_ids         = [aws_subnet.subnet_for_lambda.id]
##    security_group_ids = [aws_security_group.sg_for_lambda.id]
##  }
##
##  # Explicitly declare dependency on EFS mount target.
##  # When creating or updating Lambda functions, mount target must be in 'available' lifecycle state.
##  depends_on = [aws_efs_mount_target.alpha]
##}
##
### EFS file system
##resource "aws_efs_file_system" "efs_for_lambda" {
##  tags = {
##    Name = "efs_for_lambda"
##  }
##}
##
### Mount target connects the file system to the subnet
##resource "aws_efs_mount_target" "alpha" {
##  file_system_id  = aws_efs_file_system.efs_for_lambda.id
##  subnet_id       = aws_subnet.subnet_for_lambda.id
##  security_groups = [aws_security_group.sg_for_lambda.id]
##}
##
### EFS access point used by lambda file system
##resource "aws_efs_access_point" "access_point_for_lambda" {
##  file_system_id = aws_efs_file_system.efs_for_lambda.id
##
##  root_directory {
##    path = "/lambda"
##    creation_info {
##      owner_gid   = 1000
##      owner_uid   = 1000
##      permissions = "777"
##    }
##  }
##
##  posix_user {
##    gid = 1000
##    uid = 1000
##  }
##}
##
##variable "lambda_function_name" {
##  default = "lambda_function_name"
##}
##
##resource "aws_lambda_function" "test_lambda" {
##  function_name = var.lambda_function_name
##
##  # ... other configuration ...
##  depends_on = [
##    aws_iam_role_policy_attachment.lambda_logs,
##    aws_cloudwatch_log_group.example,
##  ]
##}
##
### This is to optionally manage the CloudWatch Log Group for the Lambda Function.
### If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
##resource "aws_cloudwatch_log_group" "example" {
##  name              = "/aws/lambda/${var.lambda_function_name}"
##  retention_in_days = 14
##}
##
### See also the following AWS managed policy: AWSLambdaBasicExecutionRole
##resource "aws_iam_policy" "lambda_logging" {
##  name        = "lambda_logging"
##  path        = "/"
##  description = "IAM policy for logging from a lambda"
##
##  policy = <<EOF
##{
##  "Version": "2012-10-17",
##  "Statement": [
##    {
##      "Action": [
##        "logs:CreateLogGroup",
##        "logs:CreateLogStream",
##        "logs:PutLogEvents"
##      ],
##      "Resource": "arn:aws:logs:*:*:*",
##      "Effect": "Allow"
##    }
##  ]
##}
##EOF
##}
##
##resource "aws_iam_role_policy_attachment" "lambda_logs" {
##  role       = aws_iam_role.iam_for_lambda.name
##  policy_arn = aws_iam_policy.lambda_logging.arn
##}
