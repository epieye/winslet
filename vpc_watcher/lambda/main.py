
def lambda_handler(event, context):
  #print(str(event))
  
  if "detail" in event:
    if "responseElements" in event['detail']:
      if "vpc" in event['detail']['responseElements']:
        if "cidrBlock" in event['detail']['responseElements']['vpc']:
          print(event['detail']['responseElements']['vpc']['cidrBlock'])

    if "userIdentity" in event['detail']:
      if "principalId" in event['detail']['userIdentity']:
        print(event['detail']['userIdentity']['principalId'])

