##############################################################################
#                                                                            #
#                                                                            #
##############################################################################

import requests
import json
import yaml
import sys
import boto3
#import pprint
#import socket
#import xml.dom.minidom as minidom
#from xml.etree import cElementTree as ET
requests.packages.urllib3.disable_warnings()

## no time like the present
#today = datetime.date.today()

# Contact secret service.
#session = boto3.session.Session(profile_name='production-shared-infrastructure')
session = boto3.session.Session()
client = session.client(
    service_name='sts',
    region_name='us-east-1'
)

encoded_message = sys.argv[1]

decoded_message = client.decode_authorization_message(
  EncodedMessage = encoded_message
)

print(json.dumps(json.loads(decoded_message['DecodedMessage']), indent=2, sort_keys=False))


