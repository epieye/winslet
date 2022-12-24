// https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-service-event.html

resource "aws_cloudwatch_event_rule" "capture-aws-sign-in" {
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

#resource "aws_cloudwatch_event_rule" "changes-all" {
#  name        = "changes-all"
#  description = "Capture All Changes"
#
#  event_pattern = <<EOF
#{
#  "account": ["742629497219"]
#}
#EOF
#}

resource "aws_cloudwatch_event_rule" "changes-ec2" {
  name        = "changes-ec2"
  description = "Capture Changes in EC2"

  event_pattern = <<EOF
{
  "source": ["aws.ec2"]
}
EOF
}

resource "aws_cloudwatch_event_rule" "changes-rds" {
  name        = "changes-rds"
  description = "Capture Changes in RDS"

  event_pattern = <<EOF
{
  "source": ["aws.rds"]
}
EOF
}

resource "aws_cloudwatch_event_rule" "changes-auto" {
  name        = "changes-auto"
  description = "Capture Changes in Autoscaling"

  event_pattern = <<EOF
{
  "source": ["aws.autoscaling"]
}
EOF
}

resource "aws_cloudwatch_event_rule" "changes-r53" {
  name        = "changes-r53"
  description = "Capture Route53 Changes"

  event_pattern = <<EOF
{
  "source": ["aws.route53"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["route53.amazonaws.com"],
    "eventName": ["ChangeResourceRecordSets"]
  }
}  
EOF
}

resource "aws_cloudwatch_event_rule" "changes-ssm" {
  name        = "changes-ssm"
  description = "Capture SSM Changes"

  event_pattern = <<EOF
{
  "source": ["aws.ssm"]
}
EOF
}

resource "aws_cloudwatch_event_rule" "changes-ec2messages" {
  name        = "changes-ec2messages"
  description = "Capture EC2 Messages"

  event_pattern = <<EOF
{
  "source": ["aws.ec2messages"]
}
EOF
}

resource "aws_cloudwatch_event_rule" "changes-ssmmessages" {
  name        = "changes-ssmmessages"
  description = "Capture SSM Messages"

  event_pattern = <<EOF
{
  "source": ["aws.ssmmessages"]
}
EOF
}


# scheduled events hourly daily monthly 60 days for imperva keys

# Other examples
#{
#  "source": ["aws.ec2"],
#  "detail-type": ["AWS API Call via CloudTrail"],
#  "detail": {
#    "eventSource": ["ec2.amazonaws.com"]
#  }
#}
#
#{
#  "source": ["aws.ec2"],
#  "detail-type": ["EC2 Instance State-change Notification"]
#}
#
#{
#  "source": ["aws.rds"],
#  "detail-type": ["RDS DB Instance Event"]
#}
#
#{
#  "source": ["aws.autoscaling"],
#  "detail-type": ["EC2 Instance Launch Successful", "EC2 Instance Terminate Successful", "EC2 Instance Launch Unsuccessful", "EC2 Instance Terminate Unsuccessful", "EC2 Instance-launch Lifecycle Action", "EC2 Instance-terminate Lifecycle Action"]
#}
