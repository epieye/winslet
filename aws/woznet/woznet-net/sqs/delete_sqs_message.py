# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/sqs.html
# https://www.learnaws.org/2020/12/17/aws-sqs-boto3-guide/#how-to-create-a-new-sqs-queue-using-boto3

import boto3
import json

session = boto3.session.Session()
client = session.client(
  service_name='sqs',
  region_name='us-east-1'
)


response = client.delete_message(
  QueueUrl="https://queue.amazonaws.com/742629497219/R",
  ReceiptHandle="AQEBu4PMbz23/UtZo9+TinSRGVADqQBzmQOu5e1cDftWjaIaXjAXyhOoGsAnohnDkDSdlKdH08AehjR7CDD2UlGuBHW/01RKn7QMzvYkKVJbreNlO/AWYW94l3wQSTKUTFoMSDu/DiKV7f8A94Fck1OqgsiJk0IwKw9Ga0GPmDHENy4wNkQvDs3R6kIubQaRv2mIVgaOOsuSH+YLEOJasw2I3NnboO0WcOqSuPaiGiBQUwwMKKGZQIIHNXJSLgwjoknrZ1i2xFw+H7z45OZxDaOw6weFIm+7eSNc7JPekl6RTUDU+I6uU/HOMpoRHkQUaOVsU2vFGQsCQqYV5pGrMItwAEeH0EhCAY9PMBVhxT7Xd17vYgbH/y/sNqfK07QW4ZMz"
)

print(response)

