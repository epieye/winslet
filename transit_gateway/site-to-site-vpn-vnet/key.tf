# Create SSH key for azure user. But use user_data to add Algiers key to the VMs for user warren.
resource "tls_private_key" "Athens_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

