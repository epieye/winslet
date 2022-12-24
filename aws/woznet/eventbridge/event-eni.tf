resource "aws_lambda_function" "eni_trigger" {
  filename = "lambdas/eni_trigger.zip"
  function_name = "eni_trigger"
  #role = aws_iam_role.iam_for_eventbridge.arn  # this is now in the ../iam subdir. I guess I need to output it. 
  role = data.terraform_remote_state.iam.outputs.event_bridge_arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
}

// roles and rules are defined in their own files now
resource "aws_cloudwatch_event_target" "lambda_eni" {
  #rule = "${aws_cloudwatch_event_rule.changes-eni.name}" # try it without the "${}"
  rule = aws_cloudwatch_event_rule.changes-eni.name
  target_id = "eni_trigger"
  arn = aws_lambda_function.eni_trigger.arn
}

resource "aws_lambda_permission" "allow_lambda4eni" {
  statement_id = "AllowExecutionFromCloudWatchAndExecuteLambda4Rds"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.eni_trigger.arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.changes-eni.arn
}

resource "aws_cloudwatch_event_rule" "changes-eni" {
  name        = "changes-eni"
  description = "Capture ENI Changes"

  event_pattern = <<EOF
{
  "source": ["aws.ec2"]
}
EOF
}

#  "detail": {
#    "eventSource": ["elasticloadbalancing.amazonaws.com"],
#    "eventName": ["NetworkInterface"]
# DeleteNetworkInterface 
# presumably CreateNetworkInterface
# 'invokedBy': 'elasticloadbalancing.amazonaws.com'
#  }

