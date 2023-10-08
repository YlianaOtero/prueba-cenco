#!/bin/bash

set -e  

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

read -p "Enter the IP address of the master server: " SERVER_IP
read -p "Enter the IP address of the agent (worker) server: " AGENT_IP

join_k3s_agent() {
  k3sup join --ip $AGENT_IP --server-ip $SERVER_IP --user $USER
}

main() {
  join_k3s_agent
  echo "Agent joined to the k3s cluster."
}

main