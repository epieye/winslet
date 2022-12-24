# add this to user_data

sudo amazon-linux-extras install epel -y
sudo yum install -y stress

stress --cpu 8 # 8 threads in the background 
