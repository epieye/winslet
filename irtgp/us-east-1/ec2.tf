/*
  Create an EC2 in the Woznet VPC.
*/

#data "template_file" "user_data" {
#  template = file("user_data.sh")
#}

data "aws_ami" "amznix2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  owners = ["amazon"]
}

## We can't use the local variable for the resource name. Role name neither.
#Make is different for each, or put a commons iam outside this
#resource "aws_iam_instance_profile" "ec2_profile" {
#  name = "ec2_policy_profile"
#  role = aws_iam_role.ec2_policy.name
#}
#
#resource "aws_iam_role" "ec2_policy" {
#  name = "ec2_policy"
#
#  assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": ["ec2.amazonaws.com"]
#      }
#    }
#  ]
#}
#EOF
#}
#
#resource "aws_iam_role_policy" "ec2_policy" {
#  name = "allow_ec2_to_access_things"
#  role = aws_iam_role.ec2_policy.id
#
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = [
#          "secretsmanager:GetSecretValue*"
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#      {
#        Action = [
#          "kms:*"
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#      {
#        Action = [
#          "ec2:*"
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#      {
#        Action = [
#          "s3:*"
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#      {
#        Action = [
#          "lambda:*"
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#      {
#        Action = [
#          "sqs:*"
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      }
#    ]
#  })
#}

resource "aws_instance" "ec2_public" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "${local.ec2_type}"

  #iam_instance_profile = aws_iam_instance_profile.ec2_common_profile.name
  iam_instance_profile = data.terraform_remote_state.iam.outputs.ec2_common_profile_name

  key_name = "${local.keypair}"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.woznet-public-sg.id]
  subnet_id = aws_subnet.woznet_subnet_public_1a.id
  #user_data = data.template_file.user_data.rendered
  user_data     = <<-EOF
    #!/bin/bash
    aws s3 cp s3://ourzoo.us/user_data.sh - | sh
  EOF

  root_block_device {
    volume_size = 30
    encrypted   = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "${local.ec2_name}"
  }
}

resource "aws_route53_record" "ec2-pub" {
  zone_id = "Z07643963KV3I332WTGCB"
  name    = "${local.ec2_name}-pub.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.ec2_public.public_ip]
}

resource "aws_instance" "ec2_private" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "${local.ec2_type}"
 
  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  iam_instance_profile = data.terraform_remote_state.iam.outputs.ec2_common_profile_name
 
  key_name = "${local.keypair}"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.woznet-private-sg.id]
  subnet_id = aws_subnet.woznet_subnet_private_1a.id
  #user_data = data.template_file.user_data.rendered
  user_data     = <<-EOF
    #!/bin/bash
    aws s3 cp s3://ourzoo.us/user_data.sh - | sh
  EOF
 
  root_block_device {
    volume_size = 30
    encrypted   = true
  }
 
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
    instance_metadata_tags = "enabled"
  }
 
  tags = {
    Name = "${local.location}-private-ec2"
  }
}

resource "aws_route53_record" "ec2-priv1" {
  zone_id = "Z07643963KV3I332WTGCB"
  name    = "${local.ec2_name}-priv1.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.ec2_private.private_ip]
}

resource "aws_instance" "ec2_private2" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "${local.ec2_type}"
 
  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  iam_instance_profile = data.terraform_remote_state.iam.outputs.ec2_common_profile_name
 
  key_name = "${local.keypair}"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.woznet2-private-sg.id]
  subnet_id = aws_subnet.woznet2_subnet_private_1a.id
  #user_data = data.template_file.user_data.rendered
  user_data     = <<-EOF
#!/bin/bash
aws s3 cp s3://ourzoo.us/user_data.sh - | sh
  EOF
 
  root_block_device {
    volume_size = 30
    encrypted   = true
  }
 
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
    instance_metadata_tags = "enabled"
  }
 
  tags = {
    Name = "${local.location}-private2-ec2"
  }
}

resource "aws_route53_record" "ec2-priv2" {
  zone_id = "Z07643963KV3I332WTGCB"
  name    = "${local.ec2_name}-priv2.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.ec2_private2.private_ip]
}

