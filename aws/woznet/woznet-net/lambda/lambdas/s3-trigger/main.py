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

  #event is {
  # 'Records': [
  #   {'eventVersion': '2.1', 
  #    'eventSource': 'aws:s3', 
  #    'awsRegion': 'us-east-1', 
  #    'eventTime': '2021-12-12T22:40:46.718Z', 
  #    'eventName': 'ObjectCreated:Put', 
  #    'userIdentity': {'principalId': 'AWS:AIDA2Z2BK3GBVFG7YXYZU'}, 
  #    'requestParameters': {'sourceIPAddress': '172.125.57.137'}, 
  #    'responseElements': {i
  #      'x-amz-request-id': 'WPFMB9JN4B781Y2R', 
  #      'x-amz-id-2': 'mHc26PwR6IeXGWvSb87Js5gfZGzba008vJM72BRoU7up8p0OOZVigBgM7KGz/BA/a809w7WlSar7uy1YZTOmlt86omtLpS8r'
  #    }, 
  #    's3': {
  #      's3SchemaVersion': '1.0', 
  #      'configurationId': 'tf-s3-lambda-20211212215825503700000001', 
  #      'bucket': {
  #        'name': 'www.ourzoo.us', 
  #        'ownerIdentity': {
  #          'principalId': 'A1R184SZZRPK4X'
  #        }, 
  #        'arn': 'arn:aws:s3:::www.ourzoo.us'
  #      }, 
  #      'object': {
  #        'key': 'Barnaby-test3.txt', 
  #        'size': 1025, 
  #        'eTag': 'd16278bccce33c1401087de88a2fec03', 
  #        'sequencer': '0061B67A6EA474E962'
  #      }
  #    }
  #  }
  #]
  #}

  # Is there ever more than one element?
  message = "File " + str(event['Records'][0]['s3']['object']['key']) + " was uploaded to s3-bucket:" + \
                      str(event['Records'][0]['s3']['bucket']['name']) + " at " + \
                      str(event['Records'][0]['eventTime']) + "."

  # Send a message via Slack
  (response, status_code) = send_message(slack_token, message)
  # exit if status_code !~ 200. Perhaps try again.

  #return(response, status_code). 

  # print("Received event: " + json.dumps(event, indent=2))
  return { 
    'message' : "ok"
  }
