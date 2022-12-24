######################################################################
#                                                                    #
# Test lambda by sending message to Slack.                           #
# See eventbridge for in-development code (i.e. don't dev this).     #
#                                                                    #
######################################################################

import json
import yaml
import base64
import boto3
import requests
requests.packages.urllib3.disable_warnings()

# To-do: generalize this (get any secret)
# do not need to define profile_name when running within AWS. Do I need to specify region_name too?
# How to I test when I need the profile?
def get_secret(secret):
  session = boto3.session.Session() #profile_name='ourzoo-root')
  client = session.client(
      service_name='secretsmanager',
      region_name='us-east-1'
  )
  get_secret_value_response = client.get_secret_value(SecretId=secret)
  username = 'warren.matthews@onedatascan.com'
  slack = json.loads(get_secret_value_response["SecretString"])
  token  = slack['token']
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

  # Send a message via Slack
  (response, status_code) = send_message(slack_token, "Bi-daily message via API.")
  # exit if status_code !~ 200. Perhaps try again.

  #return(response, status_code). 

  # print("Received event: " + json.dumps(event, indent=2))
  return { 
    'message' : "ok"
  }