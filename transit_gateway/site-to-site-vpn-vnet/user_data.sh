#!/usr/bin/bash

echo "this" > /tmp/test.txt
apt install net-tools

touch /home/azureuser/user_data.txt

useradd -m -G sudo -u 1100 -c "Warren Matthews" -d /home/warren -s /bin/bash warren
su - warren -c 'ssh-keygen -b 2048 -f ~/.ssh/id_rsa -q -N ""' 


# Do the Azure VMs come with powershell installed? Get-AzVM.

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
echo "Greetings Professor Falken."
EOF



