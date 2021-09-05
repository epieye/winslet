#!/bin/bash

yum update --skip-broken -y
yum install epel-release -y
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
pip3 install requests
pip3 install boto3
pip3 install pyyaml
pip3 install python-nmap
pip3 install pylint

systemctl start docker
systemctl enable docker

# Forward syslog to central server.
sed -i.bak s"/#*.* @@remote-host:514/*.* @@192.168.2.166:514/" /etc/rsyslog.conf
systemctl restart rsyslog

# This is only on the receiver
sed -i s"/#$ModLoad imudp/$ModLoad imudp/" /etc/rsyslog.conf
sed -i s"/#$UDPServerRun 514/$UDPServerRun 514/" /etc/rsyslog.conf
sed -i s"/#$ModLoad imtcp/$ModLoad imtcp/" /etc/rsyslog.conf
sed -i s"/#$InputTCPServerRun 514/$InputTCPServerRun 514/ /etc/rsyslog.conf
#$PreserveFQDN on
# $template DynaFile,"/data/syslog/%HOSTNAME%/%HOSTNAME%-%$YEAR%-%$MONTH%-%$DAY%-%$HOUR%.log"
#*.* -?DynaFile
#systemctl restart rsyslog

# I don't remember doing anything special to get sudo access before. 
echo "warren    ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/local_admin

useradd -m -G wheel,docker -u 1100 -c "Warren Matthews" -d /home/warren -s /bin/bash warren
su - warren -c 'ssh-keygen -b 2048 -f ~/.ssh/id_rsa -q -N ""' 

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0n4EDl6ksSuiQTw9Jt6rLbCo0b+rDCuAFDCN2Y5vxihDR8kKx7JHkIZLH7njAy4kDSaqjRbBE86Gfq36JCfZFYjxzBNDAeIDoM9irBuaq7iOOJs94H/d+48HIPrxa8oeHYsrwAyTZqJZsc4euI6/IMnB+wLYuC++zo0INxWLQhhtiB70rc+Uf/fG8JX/vF6GXbd18x46kBea6PvN3OpfyMnX5onYotXL09IABCUZqZyb0q+GFyHXBBSi6V1VDboGOXerpdbqWcAwXm5NxOkPx7mohNIGrR+JdBKcMj+mGSf9qZsbi+djJbFB0OOVkL8SrXNKDHuXUWHn9L3GmSOLB warren@mojave" >> /home/warren/.ssh/authorized_keys
chown warren:warren /home/warren/.ssh
chmod 755 /home/warren/.ssh
chown warren:warren /home/warren/.ssh/authorized_keys
chmod 400 /home/warren/.ssh/authorized_keys

# Make this a secret.
mkdir /home/warren/.aws
chown warren:warren /home/warren/.aws
echo "[default]" > /home/warren/.aws/credentials
echo "aws_access_key_id = AKIA2Z2BK3GB2NPSJAOM" >> /home/warren/.aws/credentials
echo "aws_secret_access_key = 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" >> /home/warren/.aws/credentials
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

sh update_terraform.sh
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

# slack message. Put token in secrets file. 
