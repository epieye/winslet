

###ORIGINAL AMI DEFAULT -- (needs to be pulled out at some point)
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




#####MANAGE USERDATA DEFAULT SCRIPTING FOR ANSIBLE
#
#
####GET ANSIBLE SECRETS from AWS SECRETS MGR
###Cross account/poweruser role access grants is governed by policy on the secrets themselves
###-and customer based key (cms) is established under key manager (terraformed via prod-shared-infrastructure/ansible-runner/secrets.tf
#
###WINDOWS (admin pw and key)
#
#data "aws_secretsmanager_secret" "ec2-win-ansible-secrets-key" {
#  arn = "arn:aws:secretsmanager:us-east-1:697672003593:secret:ansible-target-pubkey-mFEZZc"
#}
#
#data "aws_secretsmanager_secret_version" "ec2-win-ansible-target-pubkey" {
#  secret_id = data.aws_secretsmanager_secret.ec2-win-ansible-secrets-key.id
#}
#
#
###LINUX (rsa key)
#data "aws_secretsmanager_secret" "ec2-linux-ansible-secrets-key" {
#  arn = "arn:aws:secretsmanager:us-east-1:697672003593:secret:ansible-target-rsakey-BRhUNU"
#}
#
#data "aws_secretsmanager_secret_version" "ec2-linux-ansible-target-rsakey" {
#  secret_id = data.aws_secretsmanager_secret.ec2-linux-ansible-secrets-key.id
}



#SEE VARIABLES.TF! OWNER ID SHOULD BE PASSED BUT DEFAULT IS AMZ (required for platform determination -- to target appropriate userdata script)

###GET AMI PLATFORM

data "aws_ami" "ami_platform" {

  filter {
    name   = "image-id"
    values = [var.ami_id]
  }
  
  #REQUIRED VAR:
  owners = [var.ami_owner_id]
}


###SET USERDATA SCRIPT TYPE/TARGET
locals {
  ansible_script_target = (data.aws_ami.ami_platform.platform == "windows" ? "winrm_userdata.ps1" : "amzlinux_userdata.sh")
}


###REF USERDATA SCRIPT TO FIRE ON STANDUP + PASS RSA KEY OR X509 PUB FOR WIN
#data "template_file" "ec2_ansible_userdata" {
#  template = file("${path.module}/${local.ansible_script_target}")
#  vars = {
#    ansrsapubkey = data.aws_secretsmanager_secret_version.ec2-linux-ansible-target-rsakey.secret_string,
#    pubkey = data.aws_secretsmanager_secret_version.ec2-win-ansible-target-pubkey.secret_string
#  }
#}

##################################################################################################


###BUILD EC2

resource "aws_instance" "instance" {
  ami           = var.ami_id == "" ? data.aws_ami.ubuntu.id : var.ami_id
  instance_type = var.type

  ###INCLUDE ANSIBLE USERDATA DEFAULT SCRIPTING
  user_data = <<EOF
  #${data.template_file.ec2_ansible_userdata.rendered}
  
  ${var.user_data}
  EOF
  ####################################################

  key_name = var.key_name
  iam_instance_profile = var.instance_profile
  root_block_device  {
    encrypted = true
    volume_size = var.disk_size
  }
  vpc_security_group_ids = [var.vpc_sec_group]
  subnet_id = var.subnet_id
  associate_public_ip_address = var.public_ip ? true : false
  
  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [ami, user_data]
  }
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
}

output "ec2_id" {
  value = aws_instance.instance.id
}

output "ec2_instance" {
  value = aws_instance.instance
}

