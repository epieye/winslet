########################################################################################################################
#                                                                                                                      #
# Create top level public and private kinaida.net (onedatascan.io) zones in PSI dns-private_route53_zones.tf           #
# In this case, kinaida.net public zone is permanent.                                                                  #
# internal.kinaida.net is created in zones.tf. Change it to dns-private_route53_zones.tf to keep things clear.         #
# private kinaida.net too.                                                                                             #
# More subdomains. I need to host in one EC2 and have it resolve another one. 
# Make sure enableDnsHostnames and enableDnsSupport are true.                                                          #
#                                                                                                                      #
# dns-resource_access_manager.tf I don't think I need to change this. I think it's just cross-account.                 #
#                                                                                                                      #
# dns-private_route53_zones.tf   Use module, but what VPC? monitoring-vpc or systems-management-vpc but do I have to?  #
#                                                                                                                      #
# dns-internal_route53_resolver.tf - change domain_name = "ec2.onedatascan.io" to just onedatascan.io                  #
#                                                                                                                      #
# dns-internal_route53_resolver_other_account_subzones.tf                                                              #
#                                                                                                                      #
########################################################################################################################


# The resource sharing configuration for internal DNS zones
# Associate the resources
# Associate the OrgUnits. In case I make more use of them, or add one that I want to use. 
# Associate Un-managed Accounts (Dev/QA Original)
# Maybe I do need this after all. I thought it was just for sharing between accounts.

#resource "aws_ram_resource_share" "ram_share_internal_dns" {
#  name                      = "ram-share-internal-dns"
#  allow_external_principals = true
#
#  tags = { Name = "ram-share-internal-dns" }
#}
#
#resource "aws_ram_resource_association" "ram_res_assoc_kinaidanet" {
#  resource_arn       = aws_route53_resolver_rule.fwd_kinaidanet.arn
#  resource_share_arn = aws_ram_resource_share.ram_share_internal_dns.arn
#}
#
#resource "aws_ram_resource_association" "ram_res_assoc_intkinaidanet" {    
#  resource_arn       = aws_route53_resolver_rule.fwd_intkinaidanet.arn
#  resource_share_arn = aws_ram_resource_share.ram_share_internal_dns.arn
#}
#
#resource "aws_ram_resource_association" "ram_res_assoc_lonkinaidanet" {    
#  resource_arn       = aws_route53_resolver_rule.fwd_lonkinaidanet.arn
#  resource_share_arn = aws_ram_resource_share.ram_share_internal_dns.arn
#}
#
#resource "aws_ram_resource_association" "ram_res_assoc_ohikinaidanet" {    
#  resource_arn       = aws_route53_resolver_rule.fwd_ohikinaidanet.arn
#  resource_share_arn = aws_ram_resource_share.ram_share_internal_dns.arn
#}





# dns-private_route53_zones.tf
# See zones.tf
# Or do I dynamically create them? 
# What were the zones? london etc. oh yes, there in the relevant folders. How do I know which ones to add?
# Also see sg.tf

# dns-internal_route53_resolver.tf

# Inbound Resolver Endpoint - Receive DNS requests from other VPCs
resource "aws_route53_resolver_endpoint" "kinaida_inbound_resolver" {
  name      = "kinaida_inbound_resolver"
  direction = "INBOUND"

  security_group_ids = [aws_security_group.inbound_resolver_sec_group.id]

  ip_address {
    subnet_id = aws_subnet.woznet_subnet_private_1a.id    # For every AZ, what about public subnet?
  }

  ip_address {
    subnet_id = aws_subnet.woznet_subnet_private_1b.id
  }

  tags = { Name = "inbound-resolver" }
}




# Outbound Resolver Endpoint - Forward DNS requests for non-R53 and non-local zones
resource "aws_route53_resolver_endpoint" "kinaida_outbound_resolver" {
  name      = "kinaida_outbound_resolver"
  direction = "OUTBOUND"

  security_group_ids = [aws_security_group.inbound_resolver_sec_group.id]

  ip_address {
    subnet_id = aws_subnet.woznet_subnet_private_1a.id
  }

  ip_address {
    subnet_id = aws_subnet.woznet_subnet_private_1b.id
  }

  tags = { Name = "outbound-resolver" }
}


# Outbound Resolver Forward Rule - valhalla.id

# Outbound Resolver Forward Rules  - forward to inbound for resolution of private R53 zones
resource "aws_route53_resolver_rule" "fwd_kinaidanet" {
  domain_name          = "kinaida.net"        
  name                 = "fwd_kinaidanet"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.kinaida_outbound_resolver.id

  target_ip {
    ip = "192.168.12.2" # Replace with a reference if i can.
  }

  tags = { Name = "outbound-resolver-rule-kinaida-net" }
}

# internal_kinaida.net
# london
# ohio

# Outbound Resolver Forward Rules  - forward to inbound for resolution of private R53 zones
resource "aws_route53_resolver_rule" "fwd_intkinaidanet" {
  domain_name          = "internal.kinaida.net"        
  name                 = "fwd_intkinaidanet"  
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.kinaida_outbound_resolver.id

  target_ip {
    ip = "192.168.13.2" # Replace with a reference if i can.
  }

  tags = { Name = "outbound-resolver-rule-internal-kinaida-net" }  
}

resource "aws_route53_resolver_rule" "fwd_lonkinaidanet" {
  domain_name          = "london.kinaida.net"
  name                 = "fwd_lonkinaidanet"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.kinaida_outbound_resolver.id

  target_ip {
    ip = "192.168.14.2" # Replace with a reference if i can.
  }

  tags = { Name = "outbound-resolver-rule-london-kinaida-net" }
}

resource "aws_route53_resolver_rule" "fwd_ohikinaidanet" {
  domain_name          = "ohio.kinaida.net"
  name                 = "fwd_ohikinaidanet"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.kinaida_outbound_resolver.id

  target_ip {
    ip = "192.168.15.2" # Replace with a reference if i can.
  }

  tags = { Name = "outbound-resolver-rule-ohio-kinaida-net" }
}

# Outbound Resolver Rule Associations - The VPC hosting the R53 zones only needs rules for external zones
#resource "aws_route53_resolver_rule_association" "fwd_kinaidanet" {
#  resolver_rule_id = aws_route53_resolver_rule.fwd_kinaidanet.id
#  vpc_id           = aws_vpc.woznet_vpc1.id   # what's the equivalent of the domain_services_vpc ?
#}

resource "aws_route53_resolver_rule_association" "fwd_intkinaidanet" {
  resolver_rule_id = aws_route53_resolver_rule.fwd_intkinaidanet.id  
  vpc_id           = aws_vpc.woznet_vpc1.id
}

resource "aws_route53_resolver_rule_association" "fwd_lonkinaidanet" {
  resolver_rule_id = aws_route53_resolver_rule.fwd_lonkinaidanet.id
  vpc_id           = aws_vpc.woznet_vpc1.id
}

resource "aws_route53_resolver_rule_association" "fwd_ohikinaidanet" {
  resolver_rule_id = aws_route53_resolver_rule.fwd_ohikinaidanet.id
  vpc_id           = aws_vpc.woznet_vpc1.id
}

# dns-internal_route53_resolver_other_account_subzones.tf - this is the same as above, but loop through all the subdomains.

# locals has all the important information
# Outbound Resolver Forward Rules  - forward to VPC resolver for account-specific R53 zones
# Outbound Resolver Rule Associations





