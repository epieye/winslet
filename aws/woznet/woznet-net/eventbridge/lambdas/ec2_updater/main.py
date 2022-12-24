######################################################################
#                                                                    #
# Look for relevant changes in AI-UAT and update Confluence page.    #
# Send confirmation message to Slack channel when it is done.        #
#                                                                    #
######################################################################

import json
import yaml
import base64
import boto3
import requests
requests.packages.urllib3.disable_warnings()

# To-do: generalize this (get any secret)
def get_secret(secret):
  session = boto3.session.Session(profile_name='ourzoo-root')
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

# To-do: Add logging so I can track each call. In general, not just this function.
def update_confluence(key, page_id, title, html):
  confluence_url = "https://onedatascan.atlassian.net/wiki/rest/api/content/"

  # Find the current version so we can increment it. Don't forget to expand version!
  metadata_url = endpoint + page_id + "?expand=space,metadata.labels,version"
  headers = { 'Authorization': 'Basic ' + base64_message,
              'Content-Type': 'application/json'
            }
  r = requests.get(metadata_url, headers=headers, verify=False)

  ## no need to output the results from retrieving metadata unless troubleshooting.
  #print(json.dumps(json.loads(r.text), indent=2, sort_keys=False))
  #print(r.status_code)

  version = json.loads(r.text)['version']['number']
  new_version = version + 1

  data = {
    "id": page_id,
    "type": "page",
    "title": title,
    "space": { 
      "key": key
    },
    "body": { 
      "storage": {
        "value": html,
        "representation": "storage"
      },
    },
    "version": {
      "number": new_version
    }
  }

  r = requests.put(confluence_url, data=json.dumps(data), headers=headers, verify=False)
  return(r.text, r.status_code)



# Finally ....
# The main event
def handler(event, context):
  # get the confluence secrets and craft the authorization
  
  # Connect to secret service
  slack_token = "Bearer " + get_secret("bob") # change to where and what e.g. ("slack", "token") or ("confluence", "server")

  # Retrieve the details from AWS
  # EC2
  # RDS
  # S3

  # Update confluence page
  key     = "IN"
  page_id = "5475532801"
  title   = "UAT Ai Operation and Maintenance Instance Details from API"
  html = intro + body
  (response, status_code) = update_confluence(key, page_id, title, html):
  # exit if status_code !~ 200. Send error report to Slack.

  ## Send a message via Slack
  #(response, status_code) = send_message(token, "Another message via API.")
  # exit if status_code !~ 200. Perhaps try again.

  #return(response, status_code). 
  return 1
