#// https://registry.terraform.io/modules/terraform-aws-modules/eventbridge/aws/latest
#// https://aws.amazon.com/premiumsupport/knowledge-center/route53-change-notifications/
#
#//
#resource "aws_cloudwatch_event_rule" "profile_generator_lambda_event_rule" {
##  name = "profile-generator-lambda-event-rule"
##  description = "retry scheduled every 2 min"
##  schedule_expression = "rate(2 minutes)"
#   // define-pattern: Pre-defined pattern by service -> AWS -> Route53
#   // event-type:     AWS PLI Call via CloudTrail.
#   // 
#}
#
##event_pattern": one of `event_pattern,schedule_expression` must be specified
#
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
#
#
#
#
### Krakatoa
##{
##  "source": ["aws.route53"],
##  "detail-type": ["AWS API Call via CloudTrail"],
##  "detail": {
##    "eventSource": ["route53.amazonaws.com"],
##    "eventName": ["ChangeResourceRecordSets", ""]
##  }
##}
#
## Do I need to enable cloudtrail?
#
#resource "aws_cloudwatch_event_target" "profile_generator_lambda_target" {
##  arn = module.profile_generator_lambda.lambda_function_arn
##  rule = aws_cloudwatch_event_rule.profile_generator_lambda_event_rule.name
#   // This would have been SNS topic but I want to execute my lambda code
#   // Target is lambda
#}
#
#resource "aws_cloudwatch_event_target" "sns" {
#  rule      = aws_cloudwatch_event_rule.console.name
#  target_id = "SendToSNS"
#  arn       = aws_sns_topic.aws_logins.arn
#}
#
#resource "aws_sns_topic" "aws_logins" {
#  name = "aws-console-logins"
#}
#
#resource "aws_sns_topic_policy" "default" {
#  arn    = aws_sns_topic.aws_logins.arn
#  policy = data.aws_iam_policy_document.sns_topic_policy.json
#}
#
#data "aws_iam_policy_document" "sns_topic_policy" {
#  statement {
#    effect  = "Allow"
#    actions = ["SNS:Publish"]
#
#    principals {
#      type        = "Service"
#      identifiers = ["events.amazonaws.com"]
#    }
#
#    resources = [aws_sns_topic.aws_logins.arn]
#  }
#}
#
#
#
#
#// This looks very much what I have in the lambda/ subdir 
#// event rather than lambda or s3 or ec2 ??
#resource "aws_lambda_permission" "allow_cloudwatch_to_call_rw_fallout_retry_step_deletion_lambda" {
##  statement_id = "AllowExecutionFromCloudWatch"
#  action = "lambda:InvokeFunction"
##  function_name = module.profile_generator_lambda.lambda_function_name
##  principal = "events.amazonaws.com"
##  source_arn = aws_cloudwatch_event_rule.profile_generator_lambda_event_rule.arn
#}
#
