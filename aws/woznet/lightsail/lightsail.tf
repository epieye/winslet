# aws lightsail get-blueprints

resource "aws_lightsail_instance" "https_server" {
  name              = "network-test-dev"
  availability_zone = "us-east-1a"
  blueprint_id      = "nginx"
  bundle_id         = "nano_2_0"
  #key_pair_name     = "LightsailDefaultKeyPair"
  user_data         = "user_data.sh"
  tags = {
    foo = "bar"
  }
}

output "nginx" {
  value = aws_lightsail_instance.https_server #.public_ip_address
} 

# how do I turn off ipv6

