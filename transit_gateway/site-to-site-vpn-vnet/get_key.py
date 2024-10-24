##############################################################################
#                                                                            #
# I don't need this anymore because I have a permanent key pair in secrets.  #
# But keep this code for future reference.                                   #
#                                                                            #
# Retrieve Athens private key from remote state in s3. Install in .ssh.      #
# Tie this to the terraform so it runs automatically when creation complete. #
#                                                                            #
##############################################################################

import boto3
import json

s3 = boto3.session.Session(profile_name="OurzooAWSAdministratorAccess").client(
  service_name='s3',
  region_name='us-east-1'
)

## Better to load into json object and save just the parameter that I want.
#response = s3.download_file(
#  'ourzoo.us',
#  'woznet/site-to-site-vpn.tfstate', 
#  'bob.txt'
#)

response = s3.get_object(
  Bucket='ourzoo.us', 
  Key='woznet/site-to-site-vpn-vnet.tfstate'
)

file_content = response['Body'].read().decode('utf-8')
json_content = json.loads(file_content)

## temp - fake it:
## Opening JSON file
#f = open('../../azure_wan_hub_test/terraform.tfstate.backup')
#json_content = json.load(f)
## delete the temp when I have an actual tfstate to test/use.

f = open('/home/warren/.ssh/Athens.pem', "w")
for element in json_content['resources']:
  if element['name'] == "Athens_ssh":
    for subelement in element['instances']:
      #print(subelement['attributes']['private_key_openssh'])
      f.write(subelement['attributes']['private_key_openssh'])
f.close

## Do I have the public key?
#for element in json_content['resources']:
#  if element['name'] == "Athens_ssh":
#    for subelement in element['instances']:
#      print(subelement['attributes']['public_key_openssh'])

#print("chmod 600 .ssh/Athens.pem")
#print("Upload to secrets too.")


