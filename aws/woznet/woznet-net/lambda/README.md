Standalone lambda tools 
rather than ones associated with an api_gateway
- also in sns and eventbridge. Oy. Need to consolidate.

maybe run it within terraform. Check out Matthias' lambda to update load balancer lambda.
- get an error with Matthias' lambda. Maybe because of the parameters I removed. Have to build it myself. And understand it!

---

Doc
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function

Building a lambda is way too complicated in my ever so humble opinion
- naiavely: function = code + link it to something like an api endpoint. 
- But:

- actually bare minimum is resource "aws_lambda_function" "test_lambda" 
-- and perhaps resource "aws_iam_role" "iam_for_lambda"
-- so what is the rest of that crap?



OOh. once the function is there, there is a drop-down menu for the trigger
=> I just need to add a trigger to the function?
See resource "aws_lambda_event_source_mapping" "example" {

eventbridge trigger
https://rahullokurte.com/how-to-invoke-an-aws-lambda-function-at-scheduled-intervals-with-aws-eventbridge-rule-using-terraform







Also make a pipeline? chicken/egg
- if I commit the code, can it zip it and upload the zip file to s3? Hup it when compete rather than terraform it.
- cross that bridge later. First things first.
- Actually terraform seems to be smart enough to update in-place for just a code change.

