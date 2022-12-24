# To create a new lambda function
mkdir new_function

# In the subdir, download required modules for packaging
pip3 install boto3 -t ./
pip3 install requests -t ./
pip3 install pyyaml -t ./

# write your python code, or copy it from another lambda. Bare minimum:
#
#    def lambda_handler(event, context):
#      return { 
#        'message' : "ok"
#      }

## test it. Assuming file is main.py and handler is handler (not e.g. lambda_handler)
# not sure this will work now as I took out the "profile"
#python3 -c 'import main; print(main.handler({},{}))'

# Also try invoking it in-place once it is uploaded.
#aws lambda invoke --region=us-east-1 --function-name=login_trigger output.txt

# zip it from the working directory and write it to this dir. I think -r means recursive.
rm new_function.zip
cd new_function
zip -r ../new_function.zip .
cd ..

# Previously I was uploading the zip file to s3. But no need for that as raw code in git.
# aws s3 cp new_function.zip s3://some_bucket/v1.0.0/new_function.zip

# If the lambda is already deployed, you can just update the code
aws lambda update-function-code --function-name new_function --zip-file fileb://new_function.zip --profile ourzoo-root --region us-east-1

# See README.{{ new_function }} for additional information.
