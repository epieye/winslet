# Give permission for the eventbridge to call the lambda function.
resource "aws_lambda_permission" "allow_lambda_vpc_event_watcher" {
  statement_id = "AllowExecutionFromCloudWatchAndExecuteLambdaForAlbWatcher"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.vpc_event_watcher.arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.vpc_event_watcher.arn
}

# This maps the event to the lambda function.
resource "aws_cloudwatch_event_target" "vpc_event_watcher" {
  rule = "${aws_cloudwatch_event_rule.vpc_event_watcher.name}"
  target_id = "vpc_event_watcher"
  arn = aws_lambda_function.vpc_event_watcher.arn
}

# Remember eventName is case sensitive.
resource "aws_cloudwatch_event_rule" "vpc_event_watcher" {
  name        = "vpc_event_watcher"
  description = "Capture Changes in EC2. Check Cloud Trail to see what useful eventNames might be." 

  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail": {
    "eventSource": ["ec2.amazonaws.com"],
    "eventName": ["CreateVpc"]
  }
}
EOF
}

