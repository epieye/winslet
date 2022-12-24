




import json
import yaml
import boto3
import requests
requests.packages.urllib3.disable_warnings()



target  = "warren-test2.kinaida.net"
profile = "ourzoo-root" # where is route53 record is stored.
cname   = "autodiscover.kinaida.net"
hosted_zone_id = "Z07643963KV3I332WTGCB" # How do they find this? And why do I have two zones?

# Z07646831SQ0KNEL18HUR
# Z07643963KV3I332WTGCB


# Call the Route 53 Service. 
session = boto3.session.Session(profile_name=profile)
client = session.client(
    service_name='route53',
    region_name='us-east-1'
)


# Upsert (if it doesn't exist, create it, if it does, update it). Probably want to try/except in case something doesn't work.
get_response = client.change_resource_record_sets(
  HostedZoneId=hosted_zone_id,
  ChangeBatch= {
    'Comment': 'add %s -> %s' % (target, cname),
    'Changes': [{
      'Action': 'UPSERT',
      'ResourceRecordSet': {
        'Name': target,
        'Type': 'CNAME',
        'TTL': 300,
        'ResourceRecords': [{'Value': cname}]
      }
    }]
  }
)

print(get_response)

