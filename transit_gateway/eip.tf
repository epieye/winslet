resource "aws_eip" "woznet-eip-a" {
  public_ipv4_pool = "amazon"

  tags = {
    "Name": "woznet-eip-a"
  }

  #vpc = true
}

resource "aws_eip" "woznet-eip-b" {
  public_ipv4_pool = "amazon"

  tags = {
    "Name": "woznet-eip-b"
  }

  #vpc = true
}
