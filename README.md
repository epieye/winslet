# Winslet

Originally intended to be the repo for the kubernetes terraform file. 
Now all of my terraform files. 

Currently all aws, soon azure and gcp.

README.md
modules/

common.tf
- just tags

backend.tf
- specificy s3 bucket for state files

provider.tf

It looks like I've screwed up the ourzoo and kinaida account. 
- I've recovered ourzoo. How about Kindaida?

kinaida.tf
- set up kinaida vpc, tgw attachment, sg, and ec2. But is this in the kinaida account? - no, need seperate subdir and modify provider.

ourzoo.tf
- set up ourzoo vpc, tgw attachment, sg, and ec2. 

woznet.tf
- set up woznet vpc, tgw attachment, sg, and ec2 and tgw itself.

ec2.tf
user_data.sh

# where is the kubnernetes cluster?

alb.tf
- set up an alb 



