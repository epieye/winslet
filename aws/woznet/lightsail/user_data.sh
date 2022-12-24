#!/bin/bash

# install aws keys
# git 

# add certs and nginx config
# can i git clone the html

touch /tmp/test

# https://lightsail.aws.amazon.com/ls/docs/en_us/articles/amazon-lightsail-using-lets-encrypt-certificates-with-nginx

# Approach A: Using system packages.

sudo apt-get update
sudo apt-get install software-properties-common
#sudo apt-get gpg
#sudo apt-add-repository ppa:certbot/certbot -y Oops. Approach B

sudo apt-get update -y
sudo apt-get install certbot -y


# Step 3
DOMAIN=kinaida.net
WILDCARD=*.$DOMAIN

# sudo certbot -d $DOMAIN -d $WILDCARD --manual --preferred-challenges dns certonly

#/etc/letsencrypt/live/kinaida.net/fullchain.pem
#/etc/letsencrypt/live/kinaida.net/privkey.pem
#Your cert will expire on 2022-06-09. ("certbot renew" before then)    <- Only good for 90 days !!

# upload to secrets.
# Or download

# Step 7

#sudo /opt/bitnami/ctlscript.sh stop

# why do I already have a certificate?

#sudo mv /opt/bitnami/nginx/conf/bitnami/certs/server.crt /opt/bitnami/nginx/conf/bitnami/certs/server.crt.old
#sudo mv /opt/bitnami/nginx/conf/bitnami/certs/server.key /opt/bitnami/nginx/conf/bitnami/certs/server.key.old
##sudo mv /opt/bitnami/nginx/conf/bitnami/certs/server.csr /opt/bitnami/nginx/conf/bitnami/certs/server.csr.old

#sudo ln -sf /etc/letsencrypt/live/$DOMAIN/privkey.pem /opt/bitnami/nginx/conf/bitnami/certs/server.key
#sudo ln -sf /etc/letsencrypt/live/$DOMAIN/fullchain.pem /opt/bitnami/nginx/conf/bitnami/certs/server.crt

#sudo /opt/bitnami/ctlscript.sh start

# Step 8

#sudo vim /opt/bitnami/nginx/conf/server_blocks/network-test-dev-server-block.conf
#server {
#  listen 80 default_server;
#  root /opt/bitnami/network-test-dev;
#  return 301 https://$host$request_uri;
#}


## This file exists, added server_name and return under listen 80 instead of the whole stanza. Seems to work.
#sudo vim /opt/bitnami/nginx/conf/nginx.conf

##server {
##  listen 80;
##  server_name localhost;
##  return 301 https://$host$request_uri;
##}


#sudo /opt/bitnami/ctlscript.sh restart






