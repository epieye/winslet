# Why is it prompting me for a passphrase?
output "key" {
  value = tls_private_key.Athens_ssh
  sensitive = true
}
