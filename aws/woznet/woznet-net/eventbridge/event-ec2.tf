resource "aws_lambda_function" "ec2_trigger" {
  filename = "lambdas/ec2_trigger.zip"
  function_name = "ec2_trigger"
  role = aws_iam_role.iam_for_eventbridge.arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
}

// roles and rules are defined in their own files now
resource "aws_cloudwatch_event_target" "lambda_ec2" {
  rule = "${aws_cloudwatch_event_rule.changes-ec2.name}" # try it without the "${}"
  target_id = "ec2_trigger"
  arn = aws_lambda_function.ec2_trigger.arn
}

resource "aws_lambda_permission" "allow_lambda4ec2" {
  statement_id = "AllowExecutionFromCloudWatchAndExecuteLambda4Rds"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_trigger.arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.changes-ec2.arn
}

