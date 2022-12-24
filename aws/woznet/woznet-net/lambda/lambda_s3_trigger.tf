resource "aws_iam_role" "iam_for_lambda_s3_trigger" {
  name = "iam_for_lambda_s3_trigger"

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

# Add permission to write to CloudWatch Logs.
resource "aws_iam_role_policy" "allow_lambda_s3_trigger_access_secrets" {
  name = "allow_lambda_s3_trigger_access_secrets"
  role = aws_iam_role.iam_for_lambda_s3_trigger.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_lambda_function" "scratchycoopark4_2" {                         #<- I have to change this name too
  filename = "lambdas/s3-trigger.zip"
  function_name = "ScratchyCooPark4_2"
  role = aws_iam_role.iam_for_lambda_s3_trigger.arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
}

#resource "aws_cloudwatch_event_rule" "every_five_minutes" {                  #<- So presumably this is what I've got to change such that it triggers on (say)
#    name = "every-two-minutes"                                               #<- adding something to a s3 bucket. 
#    description = "Fires every two minutes"                                  #<- 
#    schedule_expression = "rate(2 minutes)"                                  #<- 
#}

# triggered by 'aws s3 cp ourzoo.txt s3://www.ourzoo.us/Barnaby-test.txt'
resource "aws_s3_bucket_notification" "my-trigger" {                          #<- I had hoped it would just be a simple substitution
  bucket = "www.ourzoo.us"                                                    #<- was "my-bucket"

  lambda_function {                                                           #<- 
    lambda_function_arn = "${aws_lambda_function.scratchycoopark4_2.arn}"     #<- was "my-function". Make a new function so I'm sure it's working.
    events              = ["s3:ObjectCreated:*"]                              #<- 
    filter_prefix       = "Barnaby-"                                          #<- Was AWSLogs/"
    filter_suffix       = ".txt"                                              #<- 
  }
}

# This is just like allow_cloudwatch_to_call_scratchycoopark4 below
resource "aws_lambda_permission" "test" {                                     #<- aws_lambda_permission.test doesn't seem to be called by anything else.
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.scratchycoopark4_2.arn}"             #<- was "my-function". Make a new function so I'm sure it's working.
  principal = "s3.amazonaws.com"                                              #<- 
  source_arn = "arn:aws:s3:::www.ourzoo.us"                                   #<- was "my-bucket"
}



# Something like this replaces aws_s3_bucket_notification resource.
#resource "aws_cloudwatch_event_target" "scratchycoopark4_every_five_minutes" {
#    rule = "${aws_cloudwatch_event_rule.every_five_minutes.name}"
#    target_id = "scratchycoopark4"
#    arn = "${aws_lambda_function.scratchycoopark4.arn}"
#}

#resource "aws_lambda_permission" "allow_cloudwatch_to_call_scratchycoopark4" {
#    statement_id = "AllowExecutionFromCloudWatch"
#    action = "lambda:InvokeFunction"
#    function_name = "${aws_lambda_function.scratchycoopark4.function_name}"
#    principal = "events.amazonaws.com"
#    source_arn = "${aws_cloudwatch_event_rule.every_five_minutes.arn}"
#}

