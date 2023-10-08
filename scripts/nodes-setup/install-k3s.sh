#!/bin/bash

set -e  

install_k3sup() {
  curl -sLS https://get.k3sup.dev | INSTALL_K3S_EXEC='--flannel-backend=none --disable-network-policy' sh

  sudo cp k3sup /usr/local/bin/k3sup
  sudo install k3sup /usr/local/bin/k3sup
}

main() {
  install_k3sup
  echo "k3s setup completed."
}

main