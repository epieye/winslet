#### Create the Panorama Instances ####
resource "aws_instance" "this" {
  for_each                             = var.panoramas
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"
  ebs_optimized                        = true
  ami                                  = "ami-071c6b9c981daf50d"
  instance_type                        = each.value.instance_type
  iam_instance_profile                 = lookup(each.value, "iam_instance_profile", null)
  #tags = merge(
  #  {
  #    "Name" = each.value.name
  #  },
  #  var.global_tags
  #)

  root_block_device {
    delete_on_termination = true
    encrypted = true
  }

  key_name   = each.value.ssh_key_name
  monitoring = false

  private_ip                  = lookup(each.value, "private_ip", null)
  associate_public_ip_address = lookup(each.value, "public_ip", null)

  vpc_security_group_ids = [var.security_groups_map[each.value.security_groups]]
  subnet_id              = var.subnets_map[each.value.subnet_id]
}
