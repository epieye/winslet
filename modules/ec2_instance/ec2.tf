data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "instance" {
  ami           = var.ami_id == "" ? data.aws_ami.ubuntu.id : var.ami_id
  instance_type = var.type
  user_data = var.user_data
  key_name = var.key_name
  iam_instance_profile = var.instance_profile
  root_block_device  {
    encrypted = true
    volume_size = var.disk_size
  }
  vpc_security_group_ids = [var.vpc_sec_group]
  subnet_id = var.subnet_id
  associate_public_ip_address = var.public_ip ? true : false
  tags = var.tags
  lifecycle {
    ignore_changes = [ami, user_data]
  }
}
