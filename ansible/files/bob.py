##########################################################
#                                                        #
# anible-playbook -i inventory bob.yaml                  #
# test to call python script and pass ansible variables. #
#                                                        #
##########################################################

import os

this = os.environ.get("TEST")


#return 0
