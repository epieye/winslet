

# what does the default sg look like before I implement the following? - wide open like the other ones.
# what does it looks like after I implement the following? - closed. Excellent.
# presuambly the default_security_group isn't in use as I've assigned woznet_sg. 
# - indeed. But presumably if I hadn't assigned woznet_sg it would use the (now closed) default sg. Noice.
# what about creating woznet, then applying the default_security_group afterwards? Perfect. I should use this as I create woznet_sg anyway.
# destroying it didn't quite do what I expected. It doesn't seem to modify an existing security group. But never mind.


resource "aws_default_security_group" "woznet" {
  vpc_id = module.woznet.vpc_id
}

resource "aws_default_security_group" "woznet_spew" {
  vpc_id = module.woznet_spew.vpc_id
}

