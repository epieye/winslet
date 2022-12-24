#!/bin/bash

yum update --skip-broken -y
#yum install epel-release -y
amazon-linux-extras install epel -y
yum install vim-enhanced -y
yum install git -y
yum install traceroute -y
yum install yum-utils -y
yum install bind-utils -y
yum install nfs-utils -y
yum install telnet -y
yum install whois -y
yum install nmap -y
yum install iperf3 -y
yum install make gcc-c++ openssl-devel openssl -y
yum install tcpdump -y
yum install lsof -y
yum install xclock -y
yum install at -y
#yum install python3 -y
yum install python3-devel -y
#yum install python3-pip -y
yum install docker -y
#yum install rsyslog -y # 8.24 that's good enough for now. already installed.
#yum install rsyslog-elasticsearch -y
yum install stress -y
#yum install extundelete -y
#yum install python34-psycopg2 -y # can I have a version for 3.7 please. or 3.9. 
yum install gcc -y
yum install python3-devel -y
yum install postgresql -y
yum install postgresql-devel -y
yum install mysql -y
pip3 install requests
pip3 install boto3
pip3 install pyyaml
pip3 install python-nmap
pip3 install pylint
pip3 install psycopg2-binary
pip3 install sqlalchemy
pip3 install sqlalchemy-utils

systemctl start docker
systemctl enable docker

## Forward syslog to central server.
#sed -i.bak s"/#*.* @@remote-host:514/*.* @@192.168.2.166:514/" /etc/rsyslog.conf
#systemctl restart rsyslog

## This is only on the receiver
#sed -i s"/#$ModLoad imudp/$ModLoad imudp/" /etc/rsyslog.conf
#sed -i s"/#$UDPServerRun 514/$UDPServerRun 514/" /etc/rsyslog.conf
#sed -i s"/#$ModLoad imtcp/$ModLoad imtcp/" /etc/rsyslog.conf
#sed -i s"/#$InputTCPServerRun 514/$InputTCPServerRun 514/" /etc/rsyslog.conf
#$PreserveFQDN on
# $template DynaFile,"/data/syslog/%HOSTNAME%/%HOSTNAME%-%$YEAR%-%$MONTH%-%$DAY%-%$HOUR%.log"
#*.* -?DynaFile
#systemctl restart rsyslog

sudo yum install amazon-cloudwatch-agent

# create cloudwatch agent configuration file. But how do I know the destination log group? 
# need an iam role too
# my main interest is to centralize system logs, or forward some application logs
# written to /opt/aws/amazon-cloudwatch-agent/bin/config.json
#{
#	"agent": {
#		"run_as_user": "root"
#	},
#	"logs": {
#		"logs_collected": {
#			"files": {
#				"collect_list": [
#					{
#						"file_path": "/var/log/messages",
#						"log_group_name": "messages",
#						"log_stream_name": "{instance_id}"
#					}
#				]
#			}
#		}
#	},
#	"metrics": {
#		"metrics_collected": {
#			"collectd": {
#				"metrics_aggregation_interval": 60
#			},
#			"statsd": {
#				"metrics_aggregation_interval": 60,
#				"metrics_collection_interval": 60,
#				"service_address": ":8125"
#			}
#		}
#	}
#}

# motd
echo "#!/bin/bash" > /etc/update-motd.d/90-amos
echo "                                                                                           " >> /etc/update-motd.d/90-amos
echo "                                                                                           " >> /etc/update-motd.d/90-amos
echo "               AAA                                                                         " >> /etc/update-motd.d/90-amos
echo "              A:::A                                                                        " >> /etc/update-motd.d/90-amos
echo "             A:::::A                                                                       " >> /etc/update-motd.d/90-amos
echo "            A:::::::A                                                                      " >> /etc/update-motd.d/90-amos
echo "           A:::::::::A              mmmmmmm    mmmmmmm      ooooooooooo       ssssssssss   " >> /etc/update-motd.d/90-amos
echo "          A:::::A:::::A           mm:::::::m  m:::::::mm  oo:::::::::::oo   ss::::::::::s  " >> /etc/update-motd.d/90-amos
echo "         A:::::A A:::::A         m::::::::::mm::::::::::mo:::::::::::::::oss:::::::::::::s " >> /etc/update-motd.d/90-amos
echo "        A:::::A   A:::::A        m::::::::::::::::::::::mo:::::ooooo:::::os::::::ssss:::::s" >> /etc/update-motd.d/90-amos
echo "       A:::::A     A:::::A       m:::::mmm::::::mmm:::::mo::::o     o::::o s:::::s  ssssss " >> /etc/update-motd.d/90-amos
echo "      A:::::AAAAAAAAA:::::A      m::::m   m::::m   m::::mo::::o     o::::o   s::::::s      " >> /etc/update-motd.d/90-amos
echo "     A:::::::::::::::::::::A     m::::m   m::::m   m::::mo::::o     o::::o      s::::::s   " >> /etc/update-motd.d/90-amos
echo "    A:::::AAAAAAAAAAAAA:::::A    m::::m   m::::m   m::::mo::::o     o::::ossssss   s:::::s " >> /etc/update-motd.d/90-amos
echo "   A:::::A             A:::::A   m::::m   m::::m   m::::mo:::::ooooo:::::os:::::ssss::::::s" >> /etc/update-motd.d/90-amos
echo "  A:::::A               A:::::A  m::::m   m::::m   m::::mo:::::::::::::::os::::::::::::::s " >> /etc/update-motd.d/90-amos
echo " A:::::A                 A:::::A m::::m   m::::m   m::::m oo:::::::::::oo  s:::::::::::ss  " >> /etc/update-motd.d/90-amos
echo "AAAAAAA                   AAAAAAAmmmmmm   mmmmmm   mmmmmm   ooooooooooo     sssssssssss    " >> /etc/update-motd.d/90-amos
echo "                                                                                           " >> /etc/update-motd.d/90-amos
echo "                                                                                           " >> /etc/update-motd.d/90-amos
echo "                                                                                           " >> /etc/update-motd.d/90-amos
echo "                                                                                           " >> /etc/update-motd.d/90-amos
echo "                                                                                           " >> /etc/update-motd.d/90-amos
echo "                                                                                           " >> /etc/update-motd.d/90-amos

# I don't remember doing anything special to get sudo access before. 
echo "warren    ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/local_admin

useradd -m -G wheel,docker -u 1100 -c "Warren Matthews" -d /home/warren -s /bin/bash warren
su - warren -c 'ssh-keygen -b 2048 -f ~/.ssh/id_rsa -q -N ""' 

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCaau8bgIotVwiJR9W5YNxJf1iUXpu4y1v2RDpw/xHQ9BgdvMGv+7Pw7cpf8Xh+yn/wKY7VSnp3UxT7zbTIs4/uZdY4Dydh9ArADAVvtqE1KMdcnvU9DPjLJ035TbHFH1zBnsKYwDgidAxqIcL02TUINohSawg+8gZnDp9aJnypFO8bpGBeZitN/ZjbhuX2i/5UKouuPw/FJpClaRW+dPzykY8QGgQpsb4nHJWEG6AoBu5+ppOapeBG4VApz9OtqQqkIaN7VpS1VA28wp9I6bR6206oCJv2JSBKz6G/qzL5fqB4My4QAecOSnexk7NyAq5Jmi3kW6vFmkMeqxDRXqnIMqppfh8WhTzSJ0CRoECcOZAkpnjMWaAfsMWYiZwEg9fZdNHUTGzXzS+8Pm4nQYZOIs0XkEakYCmfGjnnPzqG95A74No6x9EpofbzMXv1IecwzHCOGvEEWI31LownpivOB/wB5AzK2eSVXp/Uq3mdGdMXv5gy61vQ5YyWbw+Lkjk= wofsvcf@eusadminss-MacBook-Pro.local" >> /home/warren/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCthVPykSkIFUDCnYYlhGrlr5xKYHu56O7NurlmalpMgujVvjAN640IxwanEouqCsgghIq/rDf2lRx1YWisoEqZlMX/0IX/29S+pdefRlpSy5rzN37gnbW6oS3pJNadm2Pn4+/asvbqYKxCeODor7g5ntG3lb6TGfhHiW8ssOP9iUqSPRUQ8I5kfoimPbLIMfbQlokZdiL3VVQJ8n+Ck1BPfFuvYp1yaPzJFah2ltMsTE4Pw1C1YXOi9HG1cq4Tj9aSiaegAWy4ZqiP2AgoaOOljuCOyFwknmWeLLA56Q6GTiEdjcR2Z6fxOvvD8Rcz+3+0EtPztVUIA6SzeCSb1KY9 warren@gina" >> /home/warren/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMC9TGjfbIdyW5+Av+kL3RMRqlqFcAvSykyVnJ4jyi5E2PJ4vApRPOhDCsPi2iA0IqxCS3xO93TYfv7wI9NcMrG2/b+25qgXiWoqi3VyNNGn4FY5QGRx96V98CWJ3h5bWboRQ6PkE1/uaQgykAByGGPSzreKFu+13L8RFEJkCWMCFRNpNCsfckVcrP2Wf5Ikx4v1CcXZwJwnaKAMLIoGU+krIa7fKuv9KWiqq1HZrtohIxR08SI/Lw2ccYVnkTo3fq8YyCStBxymqWhYp5IopfPdokrz4dgwGbHDrc85HGU5lP+lxnUo+qADrYkct3xFNvolGY/2xfEbANG5s4wh3p warren@rosa.ourzoo.us" >> /home/warren/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNv8dzP9pTucAIUM162HN5tRsfrHvIDWLurtWw1GgcYyvVnjXGSnT6EEBcNqHPFp8pkY1hB3y45W8pMDpOxiST4JXdps/18oDK15jx2ZRl9jjT8/0VDeYzYfWQo/WYAbiaOAIbxdmRx9aaNd7hYgczWqASEhNSWfIla9V+MqkuK/53D8a4hiyDNl1eS8HUtKorcqAmgUX2b6TI02cuba0w4j1ojpF1HqenAdkWxq9SCpaDpi3IpQJskKsER27j4C7NlFnb+l/s72PvXCk+IFhzhclx4Ilt6lHClRWVJfZmJYXpYE1+MZ+0cIY/VCDugD+ACKtdRZ14W1LMG2a/Dwih7atjd9aJoJeMOQYEnjNnZBBAj4UilqX8NitZ+0jchKypSMqa7sSn44jCqPCvbSJILYtLYWJ5A7GKc1gSoFebxqcqGm8NqxtckTTrido9Wm0/aRO6aXturVaBduCDkHM6rd7F8sFn7n/KXJfDxbojVW+sqvEHIgt923jElsehWRE= WOFSVCF@ip-192-168-2-4.ec2.internal" >> /home/warren/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQVzw5YRfs1sihX4fNNn0nri1M/voX+5wRc2VOfPVb6 JuiceSSH" >> /home/warren/.ssh/authorized_keys
chown warren:warren /home/warren/.ssh
chmod 755 /home/warren/.ssh
chown warren:warren /home/warren/.ssh/authorized_keys
chmod 400 /home/warren/.ssh/authorized_keys

# need a key or a password on the private-only servers.
# copy pem file manually until I can think of something better. Don't want to use passwords if I don't have to.
# could upload the public key to s3 once I create it. Need to create aws creds first.
#su - warren -c "aws s3 cp /home/warren/.ssh/id_rsa.pub s3://kinaida.net/                                            "

# Make this a secret.
mkdir /home/warren/.aws
chown warren:warren /home/warren/.aws
echo "[default]" > /home/warren/.aws/credentials
echo "[default]" > /home/warren/.aws/config
echo "output = json" >> /home/warren/.aws/config
echo "region = us-east-1" >> /home/warren/.aws/config

su - warren -c "aws s3 cp s3://kinaida.net/set_hostname.sh /home/warren/set_hostname.sh"
su - warren -c "sh /home/warren/set_hostname.sh"

cat > /home/warren/.bash_profile <<EOF
alias h=history
alias x=exit
alias g=grep
alias ls='ls -F'

export HISTTIMEFORMAT="%m/%d/%y %T "
export HISTSIZE=100000
unset HISTFILESIZE
export PS1='\h:\W \$ ' # h is the ip address. I want tag name woznet|ourzoo|kinaida

#sh update_terraform.sh
EOF

# vimrc too.
echo "autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o" >  /home/warren/.vimrc
echo "autocmd BufRead * set tw=0"                                                     >> /home/warren/.vimrc

# Terraform. Doesn't matter that this is an old version. It will be updated. 
curl -s https://releases.hashicorp.com/terraform/1.0.4/terraform_1.0.4_linux_amd64.zip --output terraform_1.0.4_linux_amd64.zip
unzip -q ./terraform_1.0.4_linux_amd64.zip
mv terraform /usr/local/bin/terraform

su - warren -c "aws s3 cp s3://kinaida.net/update_terraform.sh /home/warren/update_terraform.sh"

# Kubernetes
# kubectl etc
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
su - warren -c "mkdir .kube"
su - warren -c "aws eks --region us-east-1 update-kubeconfig --name winslet-eks-cluster"
# kubeadm kubelet - not sure I need these with aws eks. We'll see.
# kubeconfig - presumably don't need this until I've got a cluster.
# Install flux
curl -s https://fluxcd.io/install.sh | bash

# install https
yum -y install nginx
chkconfig nginx on
service nginx start
# put the instance number in the page like in the demo.

# something strange with nginx. Seems to be only listening on localhost
#sudo python3 -m http.server -b 192.168.4.26 80 <- use this for a quick test.

# postgres client
amazon-linux-extras install postgresql10

#cat << EOF > /home/warren/woznet_db.sql
#/* psql -h woznet-db.cdi80wpde4wf.us-east-1.rds.amazonaws.com  -p 5432 -U "postgres" -f "woznet_db.sql" -W */
#CREATE DATABASE wozdb;
#\c wozdb
#CREATE TABLE lambda (
#    id          char(36) CONSTRAINT firstkey PRIMARY KEY,
#    created     date,
#    request     varchar(40) NOT NULL,
#    type        varchar(20) NOT NULL,
#    status      varchar(20) NOT NULL
#);
#EOF
#mysql -h woznet-db.cdi80wpde4wf.us-east-1.rds.amazonaws.com -u postgres -p
#create database wozdb
#use wozdb
#CREATE TABLE IF NOT EXISTS lambda (id char(36), created datetime, updated datetime, request varchar(40) NOT NULL, request_type varchar(20) NOT NULL, request_status varchar(20) NOT NULL); 
# 
# slack message. Put token in secrets file. 
