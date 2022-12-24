resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2_policy"
  path        = "/"
  description = "Policy to provide permission to EC2"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ],
        "Resource": [
          "arn:aws:s3:::kinaida-share",
          "arn:aws:s3:::kinaida-share/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
            "kms:*"
        ],
        "Resource": [
          "arn:aws:kms:us-east-1:714474267469:key/31781865-2aeb-4aed-91db-27bbe2e133fd" # this needs to be a reference into kinaida because I'm remaking it.
        ]
      }
    ]
  })
}

# Look at the key policy in the console. Where'd all that shit come from?

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ec2_policy_role" {
  name       = "ec2_attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}
