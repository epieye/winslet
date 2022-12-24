// Thanks Steve.
data "aws_ami" "amznix2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*.*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

data "template_file" "user_data" {
  template = file("../user_data.sh")
}

#module "woznet_private_sg" {
#  source = "../../modules/security_group"
#
#  vpc_id = module.woznet.vpc_id
#
#  ingress = [
#    {
#      from_port  = 22
#      to_port = 22
#      protocol = "tcp"
#      cidr_blocks = ["192.168.4.128/26"]
#    }
#  ]
#}

// Can I reuse the value from the parent directory? Where do I define instance_type in my main ec2 file?
resource "aws_launch_template" "ourzoo-asg-template" {
  name_prefix   = "asg"
  image_id      = data.aws_ami.amznix2.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.terraform_remote_state.woznet.outputs.woznet_sg.id]
  #vpc_security_group_ids = [module.woznet_private_sg.id]
  user_data = "${base64encode(data.template_file.user_data.rendered)}"

  #tags = merge (
  #  module.configuration.tags,
  #  {      
  #    Name = "woznet_ec2"
  #  }
  #)

}
# Scaling policy? CPU network utilization/

#module "woznet_ec2" {
#  source = "../modules/ec2_instance"
#
#  ami_id = data.aws_ami.amznix2.id
#  key_name  = "Toulon"
#  subnet_id = module.woznet.private_subnet_ids[0]
#  user_data = data.template_file.user_data.rendered
#  public_ip = false
#
#  disk_size = 100
#
#  vpc_sec_group = module.woznet_sg.id
#
#  tags = merge (
#    module.configuration.tags,
#    {
#      Name = "woznet_ec2"
#    }
#  )
#}






resource "aws_autoscaling_group" "ourzoo-asg" {
  #availability_zones = ["us-east-1a"]
  vpc_zone_identifier = [
    data.terraform_remote_state.woznet.outputs.woznet_settings.private_subnet_ids[0],
    data.terraform_remote_state.woznet.outputs.woznet_settings.private_subnet_ids[1]
  ]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  health_check_grace_period = 300
  health_check_type  = "EC2"

  launch_template {
    id      = aws_launch_template.ourzoo-asg-template.id
    version = "$Latest"
  }

  # Add tags so new EC2 gets a name
}

#resource "aws_autoscaling_group" "bar" {
#  name                      = "asg-tf-test"
#  max_size                  = 5
#  min_size                  = 2
#  health_check_grace_period = 300
#  health_check_type         = "ELB"
#  desired_capacity          = 4
#  force_delete              = true
#  placement_group           = aws_placement_group.test.id
#  launch_configuration      = aws_launch_configuration.foobar.name
#  vpc_zone_identifier       = [aws_subnet.example1.id, aws_subnet.example2.id]
#
#  initial_lifecycle_hook {
#    name                 = "foobar"
#    default_result       = "CONTINUE"
#    heartbeat_timeout    = 2000
#    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
#
#    notification_metadata = <<EOF
#{
#  "foo": "bar"
#}
#EOF
#
#    #notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
#    #role_arn                = "arn:aws:iam::123456789012:role/S3Access"
#  }
#
#  #tag {
#  #  key                 = "foo"
#  #  value               = "bar"
#  #  propagate_at_launch = true
#  #}
#
#  timeouts {
#    delete = "15m"
#  }
#}
