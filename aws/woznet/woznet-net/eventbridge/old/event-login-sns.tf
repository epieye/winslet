// This works but it does not create a related subscription.
// Currently manually create subscription and confirm it.
// I don't want to send email anyway, but this is a good start.
// Try adding a text message too.
// Error code: UserError - Error message: No origination entities available to send

#resource "aws_cloudwatch_event_rule" "console" {
#  name        = "capture-aws-sign-in"
#  description = "Capture each AWS Console Sign In"
#
#  event_pattern = <<EOF
#{
#  "detail-type": [
#    "AWS Console Sign In via CloudTrail"
#  ]
#}
#EOF
#}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.console.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.aws_logins.arn
}

resource "aws_sns_topic" "aws_logins" {
  name = "aws-console-logins"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.aws_logins.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.aws_logins.arn]
  }
}
