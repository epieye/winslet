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

output "naomi" {
  value = aws_instance.naomi.private_ip
}

output "vpn_router1_ip" {
  value = aws_vpn_connection.vpn_connection.tunnel1_address
}

output "vpn_router2_ip" {
  value = aws_vpn_connection.vpn_connection.tunnel2_address
}

