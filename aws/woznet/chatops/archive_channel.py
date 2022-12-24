##################################################################
#                                                                #
# Archive a channel after we're done with it.                    #
# Probably 5 days after the ticket is closed.                    #
# There is no method for deleting a channel in the official API. #
#                                                                #
##################################################################

import requests
import json
import yaml
import boto3
import time
requests.packages.urllib3.disable_warnings()

def get_secret(secret):
  session = boto3.session.Session()
  client = session.client(
      service_name='secretsmanager',
      region_name='us-east-1'
  )
  get_secret_value_response = client.get_secret_value(SecretId=secret)
  return(json.loads(get_secret_value_response["SecretString"]))

SLACK_TOKEN  = "Bearer " + get_secret("bob")['token']
TEAM_ID = "T0EN2G6US" 
NOW = int(time.time())

# Find channels created for chatops request older than 5 days
endpoint = "https://onedatascan.slack.com/api/conversations.list?limit=1000&types=private_channel"
r = requests.get(endpoint, json = {"team_id":TEAM_ID}, headers={'Authorization': SLACK_TOKEN, 'Content-Type': 'application/json'}, verify=False)

delete_channel = []

for channel in json.loads(r.text)['channels']:
  print(channel['name'] + " " + channel['id'] + " is_archived=" + str(channel['is_archived']) + " created_at=" + str(channel['created']))
  if "chatops_request" in channel['name']:
    if channel['is_archived'] == False:
      #print(NOW-channel['created'])
      #print("5 days is " + str(60*60*24*5) + " seconds")

      if (NOW - channel['created'] > 5*24*60*60):
        print("delete this channel")
        delete_channel.append(channel['id'])

# should I pull the messages too, and make sure it's 5 days since the last message? <- 5 days, yes.
# I need to put any messages in the jira ticket anyway.

#print("total=" + str(len(json.loads(r.text)['channels'])))
#print("status_code=" + str(r.status_code))

endpoint = "https://onedatascan.slack.com/api/conversations.archive"

for channel_id in delete_channel:
  print("Deleting " + channel_id)
  r = requests.post(endpoint, json = {"channel":channel_id}, headers={'Authorization': SLACK_TOKEN, 'Content-Type': 'application/json'}, verify=False)

  #print(r.text)
  print(r.status_code)




