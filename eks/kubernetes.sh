# Install kubectl locally unless it's already installed.

kubectl version --client

if [ $? -ne 0 ]; then
  sudo dnf update -y
  sudo dnf install -y yum-utils

  cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
EOF

  sudo dnf install -y kubectl
  kubectl version --client

else
  echo "All good"
fi
