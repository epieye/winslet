output "private-ec2" {
  value = aws_instance.ec2_private.private_ip
}

output "private2-ec2" {
  value = aws_instance.ec2_private2.private_ip
}
 
