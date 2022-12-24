resource "aws_lambda_function" "ec2messages_trigger" {
  filename = "lambdas/ec2messages_trigger.zip"
  function_name = "ec2messages_trigger"
  role = aws_iam_role.iam_for_eventbridge.arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
}

// roles and rules are defined in their own files now
resource "aws_cloudwatch_event_target" "lambda_ec2messages" {
  rule = "${aws_cloudwatch_event_rule.changes-ec2messages.name}"
  target_id = "ec2messages_trigger"
  arn = aws_lambda_function.ec2messages_trigger.arn
}

resource "aws_lambda_permission" "allow_lambda4ec2messages" {
  statement_id = "AllowExecutionFromCloudWatchAndExecuteLambda4Rds"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2messages_trigger.arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.changes-ec2messages.arn
}

