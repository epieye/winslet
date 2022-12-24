import json
import yaml
import boto3
import requests
requests.packages.urllib3.disable_warnings()

# Call the Secret Service
session = boto3.session.Session(profile_name='ourzoo-root')
client = session.client(
    service_name='secretsmanager',
    region_name='us-east-1'
)

# GET the secret.
get_secret_value_response = client.get_secret_value(SecretId="imperva")

# why on earth do I have to do this. Madness I tell you.
# Doesn't matter if I upload the data with ' or " 
this = get_secret_value_response["SecretString"]
json_acceptable_string = this.replace("'", "\"")
imperva = json.loads(json_acceptable_string)

#imperva = json.loads(get_secret_value_response["SecretString"])


#server     = imperva['server']
api_id     = imperva['api_id']
api_key    = imperva['api_key']
account_id = imperva['account_id']


print(imperva)

# use create key so it can immediately be replaced.
# need to add aws_access_key_id aws_secret_access_key
# server
# api_id	API authentication identifier	
# api_key	API authentication identifier	
# account_id	Numeric identifier of the account to operate on	
# bucket_name	S3 bucket name	
# access_key	S3 access key	
# secret_key	S3 secret key[

client = session.client(
    service_name='iam',
    region_name='us-east-1'
)

# I don't have to specify the user if I'm using the keys, so does that mean I can specify the user and use my keys?
response = client.list_access_keys(UserName = "servicedog")

# verify that there is exctly only one entry. Otherwise do what? 
#print()
#print("How many keys?")
#print(len(response['AccessKeyMetadata']))

access_key_id = response['AccessKeyMetadata'][0]['AccessKeyId']
#print("access key id")
#print(access_key_id)




#print()
#print("create new key")
response = client.create_access_key(
  UserName = "servicedog"
)
#print(str(response))

new_access_key_id     = response['AccessKey']['AccessKeyId']
new_secret_access_key = response['AccessKey']['SecretAccessKey']



response = client.update_access_key(
  UserName = "servicedog",
  AccessKeyId = access_key_id,
  Status = "Inactive"
)
#print()
#print("make inactive")
#print(str(response))


response = client.delete_access_key(
  UserName = "servicedog",
  AccessKeyId = access_key_id
)

#print()
#print("delete old key")
#print(str(response))




# update imperva


# update aws secret

client = session.client(
    service_name='secretsmanager',
    region_name='us-east-1'
)




# don't forget to add server in the production secret
new_secret_string = {
  "api_id": imperva["api_id"],
  "api_key": imperva["api_key"], 
  "account_id": imperva["account_id"], 
  "bucket_name": imperva["bucket_name"], 
  "access_key": new_access_key_id, 
  "secret_key": new_secret_access_key
}

# the above is " but printing it shows '
print(new_secret_string)

# call  secret service again
put_secret_value_response = client.put_secret_value(
  SecretId="imperva", 
  SecretString = str(new_secret_string) 
)












