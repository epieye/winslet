#
#
# 
#
#

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_event_watcher_role" {
  name               = "vpc_event_watcher_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = [
      "ec2:*",
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "elasticloadbalancing:*",
    ]
    resources  = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources  = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources  = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes"
    ]
    resources  = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  name        = "policy_for_vpc_event_watcher"
  description = "policy for vpc event watcher"
  policy      = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.vpc_event_watcher_role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "managed-policy" {
  role       = aws_iam_role.vpc_event_watcher_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

