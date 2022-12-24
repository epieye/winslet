#// First stab. Let's just set a timer to trigger the lambda. 
#
#module "test_updater" {
#  #source = "git::ssh://git@git.onedatascan.io:2222/cloudops/aws-tf.git//lambda"
#  source = "../../modules/lambda/"
#
#  description = "Testing Lambda"
#  runtime = "python3.6"
#  environment = {
#  #  ALB_ID = aws_lb.ingress_alb.id,
#  #  ENDPOINTS = "devqawi-login-devqawiciax.sso.onedatascan.io:internal-a1249403ad9a943e4976045eee1dc3dc-1299789860.us-east-1.elb.amazonaws.com,devqawi-devqawimr01.wi.onedatascan.io:internal-a1249403ad9a943e4976045eee1dc3dc-1299789860.us-east-1.elb.amazonaws.com,devqawi-devqawimr01-das.wi.onedatascan.io:internal-a1249403ad9a943e4976045eee1dc3dc-1299789860.us-east-1.elb.amazonaws.com",
#  #  VPC_ID = module.ingress_vpc.vpc_id,
#  #  LISTENER_ARN = aws_lb_listener.front_end.arn
#  }
#
#  lambda_source_dir = "${path.cwd}/lambdas/ec2_updater"
#  schedule_expression = "rate(1 minute)"
#  #iam_role_arn = aws_iam_role.iam_for_alb_updater_lambda.arn
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "test_ec2_update"
#    }
#  )
#}
#
#
## Error: Provider produced inconsistent final plan
## But it (presumably) works for Matthias. 
#
#
#
##  output_lambda_zip = "${var.lambda_source_dir}/../${basename(var.lambda_source_dir)}.zip" # yes  
##  source_dir       = var.lambda_source_dir                                                 # yes
##  function_name = var.tags["Name"]                                                         # yes
##  role          = var.iam_role_arn                                                         # I don't have this
##  handler       = var.handler                                                              # I don't have this either
##  description   = var.description                                                          # yes
##  runtime = var.runtime                                                                    # Isn't this supposed to be python38 or something? But Matthias doesn't have it either.
##    variables = var.environment                                                            # I do now but it is empty
##  count = length(var.schedule_expression) > 0 ? 1 : 0                                      # yes
##  name        = "${var.tags["Name"]}_trigger"                                              # yes
##  schedule_expression    = var.schedule_expression                                         # yes
##  count = length(var.schedule_expression) > 0 ? 1 : 0                                      # yes
##  count = length(var.schedule_expression) > 0 ? 1 : 0                                      # Why do I have this twice? But yes anyway
#
