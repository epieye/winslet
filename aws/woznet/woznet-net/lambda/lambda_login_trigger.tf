// Doesn't work

resource "aws_iam_role" "iam_for_lambda_login_trigger" {
  name = "iam_for_lambda_login_trigger"

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

resource "aws_iam_role_policy" "allow_lambda_login_trigger_access_secrets" {
  name = "allow_lambda_login_trigger_access_secrets"
  role = aws_iam_role.iam_for_lambda_login_trigger.id

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

resource "aws_cloudwatch_event_rule" "console" {
  name        = "capture-aws-sign-in"
  description = "Capture each AWS Console Sign In"

  event_pattern = <<EOF
{
  "detail-type": [
    "AWS Console Sign In via CloudTrail"
  ]
}
EOF
}

# Start the default bus
# or create a dedicated bus

resource "aws_cloudwatch_event_target" "login" {
  arn = aws_lambda_function.scratchycoopark4_2.arn
  target_id = "scratchycoopark4_2"
  rule = aws_cloudwatch_event_rule.console.name
}

resource "aws_lambda_permission" "basmati" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.scratchycoopark4_2.arn}"
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.console.arn
}
