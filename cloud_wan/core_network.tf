# https://github.com/aws-ia/terraform-aws-cloudwan/blob/main/main.tf

resource "aws_networkmanager_core_network" "core_network" {
  description       = "core network"
  global_network_id = aws_networkmanager_global_network.global_network.id

  #create_base_policy = true
  #base_policy_document = jsonencode({
  #  for k, v in jsondecode(var.core_network.policy_document) : k => v
  #  if k == "version" || k == "core-network-configuration" || k == "segments"
  #})
  #
  #tags = merge(
  #  module.tags.tags_aws,
  #  module.core_network_tags.tags_aws
  #)
}

resource "aws_networkmanager_core_network_policy_attachment" "policy_attachment" {
  core_network_id = aws_networkmanager_core_network.core_network[0].id
  policy_document = 
}
