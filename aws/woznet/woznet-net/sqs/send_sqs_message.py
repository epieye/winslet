# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/sqs.html
# https://www.learnaws.org/2020/12/17/aws-sqs-boto3-guide/#how-to-create-a-new-sqs-queue-using-boto3

import boto3
import json
#import datetime
from datetime import datetime

session = boto3.session.Session()
client = session.client(
  service_name='sqs',
  region_name='us-east-1'
)


now = datetime.now().strftime("%m/%d/%Y %H:%M:%S")


message = {"now": now}


response = client.send_message(
  QueueUrl="https://queue.amazonaws.com/742629497219/R",
  MessageBody=json.dumps(message)
)
print(response)



