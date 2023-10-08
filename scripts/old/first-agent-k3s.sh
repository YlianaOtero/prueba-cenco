#!/bin/bash

# Set the IP address of the master server
export SERVER_IP=[IP SERVIDOR MASTER 0]

# Set the IP address of the agent (worker) server
export AGENT_IP=[IP SERVIDOR WORKER 0]

# Join the k3s cluster as an agent with the specified parameters
k3sup join --ip $AGENT_IP --server-ip $SERVER_IP --user $USER

echo "Agent joined to the k3s cluster."