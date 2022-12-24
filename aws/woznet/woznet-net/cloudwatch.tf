# standard monitoring for ec2 instances: cpu, mem, bits
# data.aws_region.current.name

data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "my-dashboard"

  dashboard_body = <<EOF
{
	"widgets": [{
		"type": "metric",
		"x": 0,
		"y": 0,
		"width": 12,
		"height": 6,
		"properties": {
			"view": "timeSeries",
			"stacked": false,
			"metrics": [
				["AWS/EC2", "CPUUtilization", "InstanceId", ${jsonencode(module.woznet_bastion.module_ec2.id)}]
			],
			"region": "us-east-1"
		}
	}, {
		"type": "metric",
		"x": 0,
		"y": 6,
		"width": 12,
		"height": 6,
		"properties": {
			"view": "timeSeries",
			"stacked": false,
			"metrics": [
				["AWS/EC2", "NetworkIn", "InstanceId", ${jsonencode(module.woznet_bastion.module_ec2.id)}],
				[".", "NetworkOut", ".", "."]
			],
			"region": "us-east-1"
		}
	}]
}
EOF
}
