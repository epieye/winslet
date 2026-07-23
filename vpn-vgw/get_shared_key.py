##########################################################################################
#                                                                                        #
# I have to retrieve the share key because terraform won't output it. So ducking stupid. #
#                                                                                        #
##########################################################################################

import boto3
import json

ec2 = boto3.session.Session(profile_name="OurzooAWSAdministratorAccess").client(
  service_name='ec2',
  region_name='us-east-1'
)

response = ec2.describe_vpn_connections()

print("Pre-shared keys:")

for vpn_connections in response['VpnConnections']:
  if "TunnelOptions" in vpn_connections['Options']:
    for options in vpn_connections['Options']['TunnelOptions']:
      print("172.125.57.137 " + options['OutsideIpAddress'] + ": PSK \"" + options['PreSharedKey'] + "\"")

