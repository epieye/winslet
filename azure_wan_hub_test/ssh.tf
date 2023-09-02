# Create (and display) an SSH key
resource "tls_private_key" "Athens_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

