resource "aws_kms_key" "eks_secrets_kms_key" {
  description             = "KMS Key for Encrypting EKS Secrets"
  deletion_window_in_days = 10
  #tags                    = 
}

