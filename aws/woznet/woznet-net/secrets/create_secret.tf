//


resource "aws_secretsmanager_secret" "slack_token" {
  name = "slack-token"
  description = "Slack Token"
}

// Don't want hard coded token in git.
resource "aws_secretsmanager_secret_version" "slack_token" {
  secret_id     = "${aws_secretsmanager_secret.slack_token.id}"
  secret_string = jsonencode({
    "token" = "test"
    "this" = "that"
  })
}

// rotate 60 days.
# There is an option to provide a lambda rotation function

#It will need to tie-in to slack, atlassian, imperva etc
#perhaps those tools support api change, but if not, change secret, then push it out to each account with python script - and don't commit the secret

