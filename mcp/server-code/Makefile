# Do not use quotes
THIS = onboarding
NAME = ChatOps_onboarding

zip:
		rm -f $(THIS).zip
		cd lambda && zip -qr ../$(THIS).zip . && cd -
		aws lambda update-function-code --function-name $(NAME) --zip-file fileb://$(THIS).zip --profile                               --region us-east-1 --no-cli-pager
		aws s3 cp $(THIS).zip s3://ourzoo.us                       --profile 

requirements:
		cd lambda && pip3 install --quiet -r requirements.txt -t ./ && cd -
		cd lambda && ls | grep -v "main.py" | grep -v "requirements.txt" > .gitignore && cd -

