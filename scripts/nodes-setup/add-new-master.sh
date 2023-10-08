#!/bin/bash

set -e  

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

read -p "Enter the IP address of the first master server: " SERVER_IP
read -p "Enter the IP address of the next server: " NEXT_SERVER_IP

join_k3s_cluster() {
  k3sup join --ip $NEXT_SERVER_IP --user $USER --server-user $USER --server-ip $SERVER_IP --server
}

main() {
  join_k3s_cluster
  echo "Server joined to the k3s cluster."
}

main
