#!/bin/bash

# Install k3sup with specific options
curl -sLS https://get.k3sup.dev | INSTALL_K3S_EXEC='--flannel-backend=none --disable-network-policy' sh

# Copy k3sup to /usr/local/bin/
sudo cp k3sup /usr/local/bin/k3sup
sudo install k3sup /usr/local/bin/

# Set the USER variable
export USER=ubuntu

# Copy k3s.pem to /home/ubuntu/.ssh/id_rsa
sudo cp k3s.pem /home/ubuntu/.ssh/id_rsa

echo "k3sup installation and configuration completed."
