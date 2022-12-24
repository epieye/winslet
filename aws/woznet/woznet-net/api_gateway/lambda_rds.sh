# https://docs.aws.amazon.com/lambda/latest/dg/services-rds-tutorial.html

# Use existing role: arn:aws:iam::742629497219:role/iam_for_lambda

aws rds create-db-subnet-group \
--db-subnet-group-name  "bobtodd" \
--db-subnet-group-description "bob's your uncle" \
--subnet-ids '["subnet-0016a5ff42a570a17","subnet-0765758a6116d8092"]' \
--profile ourzoo-root --region us-east-1

# create the database. vpc-04b08f1553bee4fe5
aws rds create-db-instance --db-name ExampleDB --engine MySQL \
--db-instance-identifier MySQLForLambdaTest --backup-retention-period 3 \
--db-instance-class db.t2.micro --allocated-storage 5 --no-publicly-accessible \
--master-username user --master-user-password password \
--db-subnet-group-name woznet_subnet_group
--vpc-security-group-ids sg-0a7b2700ee2af6a79 \
--profile ourzoo-root --region us-east-1

# aws rds describe-db-instances --db-instance-identifier mysqlforlambdatest | grep Address

#create the app, import pymsql
rm tutorial.zip
cd lambdas/tutorial
zip -r ../../tutorial.zip .
cd ../..
aws lambda update-function-code --function-name Diophantus --zip-file fileb://tutorial.zip --profile ourzoo-root --region us-east-1
# aws lambda get-function --function-name Diophantus | grep Last <- Look for last update status Succesful (not creating)

# create the lambda function
aws lambda create-function --function-name Diophantus --runtime python3.8 \
--zip-file fileb://tutorial.zip --handler app.handler \
--role arn:aws:iam::742629497219:role/iam_for_lambda \
--vpc-config SubnetIds=subnet-0016a5ff42a570a17,subnet-0765758a6116d8092,SecurityGroupIds=sg-0a7b2700ee2af6a79 \
--profile ourzoo-root --region us-east-1

# woznet_sg is sg-0a7b2700ee2af6a79

# 
aws lambda invoke --region us-east-1 --function-name Diophantus output.txt

# don't forget to tear down the database and the lambda function afterwards
# aws rds delete-db-instance --db-instance-identifier MySQLForLambdaTest --skip-final-snapshot --profile ourzoo-root --region us-east-1 # check for a snapshot to delete
# aws lambda delete-function --function-name Diophantus --profile ourzoo-root --region us-east-1
# aws rds delete-db-subnet-group --db-subnet-group-name="bobtodd" --profile ourzoo-root --region us-east-1
