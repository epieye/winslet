// https://docs.aws.amazon.com/sns/latest/dg/sns-getting-started.html
#Create a topic
#Create a subscription to the topic
#Publish a message to the topic

resource "aws_sns_topic" "bob_topic" {
  name = "bob-topic"
#  delivery_policy = <<EOF
#{
#  "http": {
#    "defaultHealthyRetryPolicy": {
#      "minDelayTarget": 20,
#      "maxDelayTarget": 20,
#      "numRetries": 3,
#      "numMaxDelayRetries": 0,
#      "numNoDelayRetries": 0,
#      "numMinDelayRetries": 0,
#      "backoffFunction": "linear"
#    },
#    "disableSubscriptionOverrides": false,
#    "defaultThrottlePolicy": {
#      "maxReceivesPerSecond": 1
#    }
#  }
#}
#EOF
}

resource "aws_sns_topic_subscription" "bob_topic_email_target" {
  topic_arn = aws_sns_topic.bob_topic.arn
  protocol  = "email"
  endpoint  = "warren@ourzoo.us"
}


