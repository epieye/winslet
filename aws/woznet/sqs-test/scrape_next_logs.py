######################################################################
#                                                                    #
#                                                                    #
#                                                                    #
######################################################################

import json
import yaml
import base64
from urllib.parse import urlparse, parse_qs 
import boto3
import requests
import pymysql
import uuid
requests.packages.urllib3.disable_warnings()
#from sqlalchemy import * # How's this different from import sqlalchemy?

session = boto3.session.Session()
client = session.client(
  service_name='logs',
  region_name='us-east-1'
)


#response = client.describe_log_groups (
#)

response = client.describe_log_streams(
  logGroupName = "/aws/lambda/next_trigger"
)

# sort by creation time and pick the most recent
streams = []
for logstream in response['logStreams']:
  #print(str(logstream['creationTime']) + " " + logstream['logStreamName'])
  #print()
  streams.append(str(logstream['creationTime']) + " " + logstream['logStreamName'])
  dummy = "this"

streams.sort()
for stream in streams:
  #print(stream)
  new_dummy = "that"

(timestamp, stream_name) = stream.split()
response = client.get_log_events (
  logGroupName = "/aws/lambda/sqs_trigger",
  logStreamName = stream_name
)

for event in response['events']:
  print(event)
  print()
