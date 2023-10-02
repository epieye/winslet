######################################################################################
#                                                                                    #
# My goal is to trigger get_key.py when tls_private_key.Athens_ssh has been created. #
# Wait, no, when it's written to s3. Or should I retrieve it from Azure?             #
#                                                                                    #
######################################################################################

#resource "terraform_data" "bootstrap" {
#  triggers_replace = [
#    tls_private_key.Athens_ssh
#  ]
#
#  provisioner "local-exec" {
#    command = "test.sh"
#  }
#}


#│ Error: local-exec provisioner error
#│ 
#│   with terraform_data.bootstrap,
#│   on bootstrap.tf line 13, in resource "terraform_data" "bootstrap":
#│   13:   provisioner "local-exec" {
#│ 
#│ Error running command 'test.sh': exit status 127. Output: /bin/sh: test.sh: command not found


#Maybe just the path?
