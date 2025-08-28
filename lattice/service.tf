# Similar to load balancer
# for an alb, I have a load balancer, listeners, rules, target groups, associations.
# 

#aws_vpclattice_access_log_subscription
#aws_vpclattice_auth_policy
#aws_vpclattice_resource_configuration
#aws_vpclattice_resource_gateway
#aws_vpclattice_resource_policy
#aws_vpclattice_service_network_resource_association
#aws_vpclattice_service_network_vpc_association
#aws_vpclattice_target_group_attachment

# aws_vpclattice_service_network yes
# aws_vpclattice_service yes
# aws_vpclattice_target_group yes
# aws_vpclattice_listener yes
# aws_vpclattice_service_network_service_association yes

#aws_vpclattice_listener_rule


resource "aws_vpclattice_service_network" "ourzoo" {
  name      = "ourzoo"
  auth_type = "NONE" # NONE for no authentication or authorization. or AWS_IAM for IAM policy. 
                     # example has this in service stanza
}

resource "aws_vpclattice_service" "ourzoo" {
  name = "ourzoo"

  #dns_entry {
  #  domain_name = "kinaida.net"
  #}
}

resource "aws_vpclattice_target_group" "ourzoo" {
  name = "ourzoo-target-group"
  type = "INSTANCE" # expected type to be one of ["IP" "LAMBDA" "INSTANCE" "ALB"], got VPC

  config {
    port           = 80
    protocol       = "HTTP"
    vpc_identifier = aws_vpc.woznet_vpc.id
  }
}

resource "aws_vpclattice_listener" "ourzoo" {
  name               = "ourzoo-listener"
  protocol           = "HTTP"
  service_identifier = aws_vpclattice_service.ourzoo.id

  default_action {
    fixed_response {
      status_code = 404
    }
  }
}

resource "aws_vpclattice_service_network_service_association" "ourzoo" {
  service_identifier         = aws_vpclattice_service.ourzoo.id
  service_network_identifier = aws_vpclattice_service_network.ourzoo.id
}

resource "aws_vpclattice_listener_rule" "ourzoo" {
  name                = "ourzoo"
  listener_identifier = aws_vpclattice_listener.ourzoo.listener_id
  service_identifier  = aws_vpclattice_service.ourzoo.id
  priority            = 20

  match {
    http_match {

      header_matches {
        name           = "example-header"
        case_sensitive = false

        match {
          exact = "example-contains"
        }
      }

      path_match {
        case_sensitive = true
        match {
          prefix = "/example-path"
        }
      }
    }
  }

  action {
    forward {
      target_groups {
        target_group_identifier = aws_vpclattice_target_group.ourzoo.id
        weight                  = 1
      }
      #target_groups {
      #  target_group_identifier = aws_vpclattice_target_group.example2.id
      #  weight                  = 2
      #}
    }

  }
}

resource "aws_vpclattice_service_network_vpc_association" "example" {
  vpc_identifier             = aws_vpc.example.id
  service_network_identifier = aws_vpclattice_service_network.example.id
  security_group_ids         = [aws_security_group.example.id]
}
