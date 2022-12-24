# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/sqs.html
# https://www.learnaws.org/2020/12/17/aws-sqs-boto3-guide/#how-to-create-a-new-sqs-queue-using-boto3

import boto3

session = boto3.session.Session()
client = session.client(
  service_name='sqs',
  region_name='us-east-1'
)






response = client.get_queue_url(
  QueueName="R",
)

print(response["QueueUrl"])


response = client.get_queue_url(
  QueueName="s_queue.fifo",
)

print(response["QueueUrl"])



response = client.get_queue_url(
  QueueName="t_queue.fifo",
)

print(response["QueueUrl"])



