resource "aws_autoscaling_group" "ourzoo-asg" {
  vpc_zone_identifier = [
    module.vanuatu.public_subnet_ids[0],
    module.vanuatu.private_subnet_ids[1]
  ]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  health_check_grace_period = 300
  health_check_type  = "EC2"

  #public_ip = true

  launch_template {
    id      = aws_launch_template.ourzoo-asg-template.id
    version = "$Latest"
  }

  # Add tags so new EC2 gets a name
}



#resource "aws_autoscaling_group" "web" {
#  name = "${aws_launch_configuration.web.name}-asg"
#
#  min_size             = 1
#  desired_capacity     = 2
#  max_size             = 4
#  
#  health_check_type    = "ELB"
#  load_balancers = [
#    aws_elb.web_elb.id
#  ]
#
#  launch_configuration = aws_launch_configuration.web.name
#
#  enabled_metrics = [
#    "GroupMinSize",
#    "GroupMaxSize",
#    "GroupDesiredCapacity",
#    "GroupInServiceInstances",
#    "GroupTotalInstances"
#  ]
#
#  metrics_granularity = "1Minute"
#
#  vpc_zone_identifier  = [
#    aws_subnet.public_us_east_1a.id,
#    aws_subnet.public_us_east_1b.id
#  ]
#
#  # Required to redeploy without an outage.
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  tag {
#    key                 = "Name"
#    value               = "web"
#    propagate_at_launch = true
#  }
#
#}

#UA925 Dulles 
#4.20 11.59
#£35





