
resource "aws_iam_role" "iam_for_eventbridge" {
  name = "iam_for_eventbridge"

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

resource "aws_iam_role_policy" "allow_lambda_access_secrets" {
  name = "allow_lambda_access_secrets"
  role = aws_iam_role.iam_for_eventbridge.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue*"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:secretsmanager:us-east-1:742629497219:secret:bob-OqnbKd"
      },
      {
        Action = [
          "rds-db:connect"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
# Add permission to write to CloudWatch Logs.

