data "aws_secretsmanager_secret" "base_secret" {
  count   = var.base_secret_name != "" ? 1 : 0
  name = var.base_secret_name
}

data "aws_secretsmanager_secret_version" "base_secret_version" {
  count   = var.base_secret_name != "" ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.base_secret[0].id
}

resource "aws_secretsmanager_secret" "secret" {
  name = var.tags["Name"]
  tags = var.tags
}


resource "aws_secretsmanager_secret_version" "secret_json" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(merge(var.base_secret_name != "" ? jsondecode(data.aws_secretsmanager_secret_version.base_secret_version[0].secret_string) : {}, var.secrets ))
}
