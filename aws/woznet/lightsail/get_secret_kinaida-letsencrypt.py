##########################################################
#                                                        #
# Read (GET) parameters and tokens etc from aws secrets. #
#                                                        #
##########################################################

import json
import yaml
import boto3

# Connect to secret service
session = boto3.session.Session(profile_name='ourzoo-root')
client = session.client(
    service_name='secretsmanager',
    region_name='us-east-1'
)

# retrieve the secrets (example). strict=False works around the unescaped newline character. 
get_secret_value_response = client.get_secret_value(SecretId="kinaida-letsencrypt")
letsencrypt = json.loads(get_secret_value_response["SecretString"], strict=False)

# This is ugly. There's got to be a better way.
for key in letsencrypt:
  print(key)
  print(letsencrypt[key].replace(" ", "\n").replace("-----BEGIN\n", "-----BEGIN ").replace("-----END\n", "-----END ").replace("PRIVATE\n", "PRIVATE "))


