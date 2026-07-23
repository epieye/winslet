#
# FFS. Just tell me the damn shared key.
#

#output "pre-shared-key" {
#  value = aws_vpn_connection.vpn_connection.tunnel1_preshared_key
#  sensitive = true 
#}

output "chrisjen" {
  value = aws_instance.chrisjen.private_ip
}
