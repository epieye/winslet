

# When I get something else working, this might help with the filter for trigger on a change with EC2
# But this is not auto scaling


#resource "aws_cloudwatch_event_rule" "console" {
#  name        = "capture-ec2-scaling-events"
#  description = "Capture all EC2 scaling events"
#
#  event_pattern = <<PATTERN
#{
#  "source": [
#    "aws.autoscaling"
#  ],
#  "detail-type": [
#    "EC2 Instance Launch Successful",
#    "EC2 Instance Terminate Successful",
#    "EC2 Instance Launch Unsuccessful",
#    "EC2 Instance Terminate Unsuccessful"
#  ]
#}
#PATTERN
#}

#{
#  "source": ["aws.ec2"],
#  "detail-type": ["EC2 Instance State-change Notification"],
#  "detail": {
#    "state": ["terminated"]
#  }
#}

# "source"
# and detail-type




#//
#// https://docs.aws.amazon.com/lambda/latest/dg/services-ec2.html
#// You can use AWS Lambda to process lifecycle events from Amazon Elastic Compute Cloud and manage Amazon EC2 resources. 
#// Amazon EC2 sends events to Amazon EventBridge (CloudWatch Events) for lifecycle events such as when an instance changes 
#// state, when an Amazon Elastic Block Store volume snapshot completes, or when a spot instance is scheduled to be terminated.
#//
#
#
#resource "aws_iam_role" "iam_for_lambda_ec2_trigger" {
#  name = "iam_for_lambda_ec2_trigger"
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
## Add permission to write to CloudWatch Logs.
#resource "aws_iam_role_policy" "allow_lambda_ec2_trigger_access_secrets" {
#  name = "allow_lambda_ec2_trigger_access_secrets"
#  role = aws_iam_role.iam_for_lambda_ec2_trigger.id
#
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = [
#          "secretsmanager:GetSecretValue*",
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#    ]
#  })
#}
#
#resource "aws_lambda_function" "scratchycoopark4_3" {                         #<- I have to change this name too
#  filename = "lambdas/test.zip"
#  function_name = "ScratchyCooPark4_3"                                        #<- Can I reuse the function, instead of terraforming another one.
#  role = aws_iam_role.iam_for_lambda_ec2_trigger.arn
#  handler = "main.lambda_handler"
#  runtime = "python3.9"
#}
#
### So I guess this replaces the aws_cloudwatch_event_target.scratchycoopark4_every_five_minutes
##resource "aws_s3_bucket_notification" "my-trigger" {                          #<- I had hoped it would just be a simple substitution
##  bucket = "www.ourzoo.us"                                                    #<- was "my-bucket"
##
##  lambda_function {                                                           #<- 
##    lambda_function_arn = "${aws_lambda_function.scratchycoopark4_3.arn}"     #<- was "my-function". Make a new function so I'm sure it's working.
##    events              = ["s3:ObjectCreated:*"]                              #<- 
##    filter_prefix       = "Barnaby-"                                          #<- Was AWSLogs/"
##    filter_suffix       = ".txt"                                              #<- 
##  }
##}
#
## So I guess this replaces the aws_cloudwatch_event_target.scratchycoopark4_every_five_minutes
#resource "aws_ec2_notification" "my-trigger" {
#  bucket = "www.ourzoo.us"                                                    #<- change from bucket to what? instance ID? Like the source_arn?
#
#  lambda_function {                                                           #<-
#    lambda_function_arn = "${aws_lambda_function.scratchycoopark4_3.arn}"     #<- was "my-function". Make a new function so I'm sure it's working.
#    events              = ["s3:ObjectCreated:*"]                              #<- s3:ObjectCreated:* -> ec2:??:?
#    filter_prefix       = "Barnaby-"                                          #<- Was AWSLogs/"
#    filter_suffix       = ".txt"                                              #<-
#  }
#}
#
## This is just like allow_cloudwatch_to_call_scratchycoopark4 below
#resource "aws_lambda_permission" "test" {
#  statement_id  = "AllowS3Invoke"                                             #<- ec2-events or presumably ec2Events or Ec2Events
#  action        = "lambda:InvokeFunction"
#  function_name = "${aws_lambda_function.scratchycoopark4_3.arn}"
#  principal = "events.amazonaws.com"
#  source_arn = "arn:aws:ec2:::     ??        "                                #<- source arn for the ec2? So I have to have one for every server and database?
#                                                                              #<- no, arn for the event bridge. How do I terraform this?
#}
#
#
