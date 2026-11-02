#
#
#
#
#

resource "aws_iam_role" "alb_policy" {
  name = "alb_policy"

  #managed_policy_arns   =  [
  #  "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" # Is there a managed policy arn for EC2?
  #]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "alb_policy" {
  name = "allow_ec2_to_access_things"
  role = aws_iam_role.alb_policy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "kms:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ec2:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "lambda:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "sqs:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "alb_policy_profile"
  role = aws_iam_role.alb_policy.name
}
