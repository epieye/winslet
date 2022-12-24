######################################################################
#                                                                    #
#                                                                    #
######################################################################

import json
import yaml
import base64
import boto3
import requests
requests.packages.urllib3.disable_warnings()

# To-do: generalize this (get any secret). Also helper functions in a seperate file and import them.
# How to I test when I need the profile?
def get_secret(secret):
  session = boto3.session.Session() #profile_name='ourzoo-root')
  client = session.client(
      service_name='secretsmanager',
      region_name='us-east-1'
  )
  get_secret_value_response = client.get_secret_value(SecretId=secret)
  #username = 'warren.matthews@onedatascan.com'
  #slack = json.loads(get_secret_value_response["SecretString"])
  #token  = slack['token']

  get_secret_value_response = client.get_secret_value(SecretId=secret)
  token = get_secret_value_response['token']


  return(token)

# To-do: Add certificate verification
def send_message(token, message):
  endpoint = "https://onedatascan.slack.com/api/chat.postMessage"
  channel_id = "C02B6200CD8" # Cobolt-60
  r = requests.post(endpoint, json = {"channel":channel_id,"text": message}, headers={'Authorization': token, 'Content-Type': 'application/json'}, verify=False)
  return(r.text, r.status_code)

# Finally ....
# The main event
def lambda_handler(event, context):
  # get the confluence secrets and craft the authorization
  
  # Connect to secret service
  slack_token = "Bearer " + get_secret("bob") # change to where and what e.g. ("slack", "token") or ("confluence", "server")

  message = "Lambda triggered by Route53 action: " + str(event['detail']['eventName'])
  #message = message + ". " + str(event['detail']['requestParameters']['changeBatch'])

  # limit the trigger to eventName="ChangeResourceRecordSets"
  # to-do: determine if changes are relevant (involve the imperva cnames or wotnot) and if so, fire-up confluence.

  # Send a message via Slack
  (response, status_code) = send_message(slack_token, message)

  return { 
    'message' : "ok"
  }

