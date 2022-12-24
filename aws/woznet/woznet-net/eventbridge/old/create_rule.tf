#// Keep this. Might be useful to trigger on console logins. 
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
#resource "aws_cloudwatch_event_target" "sns" {
#  rule      = aws_cloudwatch_event_rule.console.name
#  target_id = "SendToSNS"
#  arn       = aws_sns_topic.aws_logins.arn
#}
#
#// I created Orz_Test in ../sns/ 
#// aws-console-logins has no subscriptions - now it does, see below
#resource "aws_sns_topic" "aws_logins" {
#  name = "aws-console-logins" 
#}
#
#//Added a la bob_topic
#resource "aws_sns_topic_subscription" "aws_logins_email_target" {
#  topic_arn = aws_sns_topic.aws_logins.arn
#  protocol  = "email"
#  endpoint  = "warren@ourzoo.us"
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
##--
##// like aws_logins above
##resource "aws_sns_topic" "bob_topic" {
##  name = "bob-topic"
##}
##
##// so presumably create aws_logins_email_target
##resource "aws_sns_topic_subscription" "bob_topic_email_target" {
##  topic_arn = aws_sns_topic.bob_topic.arn
##  protocol  = "email"
##  endpoint  = "warren@ourzoo.us"
##}
