/*
  IAM Policy. Common for all regions.
*/

resource "aws_iam_instance_profile" "ec2_common_profile" { 
  name = "ec2_common_policy_profile"
  role = aws_iam_role.ec2_common_policy.name
}

# Reuse or rename? Reuse would be better.
resource "aws_iam_role" "ec2_common_policy" {
  name = "ec2_common_policy"

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

resource "aws_iam_role_policy" "ec2_common_policy" {
  name = "ec2_common_policy"
  role = aws_iam_role.ec2_common_policy.id

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

output "ec2_common_profile_name" {
  value = aws_iam_instance_profile.ec2_common_profile.name
}
