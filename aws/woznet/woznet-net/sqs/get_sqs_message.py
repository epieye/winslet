# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/sqs.html
# https://www.learnaws.org/2020/12/17/aws-sqs-boto3-guide/#how-to-create-a-new-sqs-queue-using-boto3

import boto3
import json

session = boto3.session.Session()
client = session.client(
  service_name='sqs',
  region_name='us-east-1'
)



# If there are no messages, it will wait up to 10 seconds for one. 
# Can I wait indefinitely?

response = client.receive_message(
  QueueUrl="https://queue.amazonaws.com/742629497219/R",
  MaxNumberOfMessages=10,
  WaitTimeSeconds=10
)

print(f"Number of messages received: {len(response.get('Messages', []))}")
#print(response['Messages'])

for message in response.get("Messages", []):
  message_body = message["Body"]
  #print(f"Message body: {json.loads(message_body)}")
  #print(json.loads(message_body)['event']['body'])
  print(f"Receipt Handle: {message['ReceiptHandle']}")
  print(message_body)

  ## I think I tried to split the query string into a dict before, how did that go? Only works for legit events from slack.
  #fields = json.loads(message_body)['event']['body'].split("&")
  #for field in fields:
  #  print(field)

  ## Delete after processing
  #response = client.delete_message(
  #  QueueUrl="https://queue.amazonaws.com/742629497219/R",
  #  ReceiptHandle=message['ReceiptHandle']
  #)  
