###################################################################
#                                                                 #
# Create a secret.                                                #
# check creds file name and profile, secret name and description. #
# or make them variable.                                          #
#                                                                 #
###################################################################

import json
import yaml
import boto3

# Load secrets from creds file. Perhap use $0 filename to guess yaml file.
try:
  with open('./creds-kinaida-letsencrypt.yaml') as f:
    data = yaml.load(f, Loader=yaml.FullLoader)
except:
  print("You must create a yaml file with the secrets. And don't forget to gitignore it. Or better still delete after use.")
  exit()

# make it a little easier on myself.
secret_data = data['secret_data']

# load secret key and value into an array
secret_string = []
for secret, value in secret_data.items():
  secret_string.append("\"" + secret + "\": \"" + str(secret_data[secret]) + "\"")

# Connect to secret service
session = boto3.session.Session(profile_name='ourzoo-root')
client = session.client(
  service_name='secretsmanager',
  region_name='us-east-1'
)

print(",".join(secret_string))

# Create (POST) a secret. 
post_secret_value_response = client.create_secret(
  Name = 'kinaida-letsencrypt', 
  Description = 'wildcard cert for kinaida.net', 
  SecretString = str("{" + ",".join(secret_string) + "}"),
  ForceOverwriteReplicaSecret = True
)

print(json.dumps(post_secret_value_response, indent=2, sort_keys=False))
