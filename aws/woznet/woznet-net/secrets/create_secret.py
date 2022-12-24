import json
import yaml
import boto3

## make it a little easier on myself.
#secret_data = 

## load secret key and value into an array
#secret_string = []
#for secret, value in secret_data.items():
#  secret_string.append("\"" + secret + "\": \"" + str(secret_data[secret]) + "\"")

# Connect to secret service
session = boto3.session.Session(profile_name='ourzoo-root')
client = session.client(
  service_name='secretsmanager',
  region_name='us-east-1'
)

## Create (POST) a secret. 
#post_secret_value_response = client.create_secret(
#  Name = 'Demigod', 
#  Description = 'testing.', 
#  #SecretString = str("{" + ",".join(secret_string) + "}"),
#  SecretString = "{\"test\": \"this\"}",
#  ForceOverwriteReplicaSecret = True
#)
#
#print(json.dumps(post_secret_value_response, indent=2, sort_keys=False))

# Amend (PUT) a secret. Cannot set ForceOverwriteReplicaSecret for update.
put_secret_value_response = client.put_secret_value(
  SecretId="Demigod", 
  SecretString = "{\"test\": \"that\"}"
)

print(json.dumps(put_secret_value_response, indent=2, sort_keys=False))

