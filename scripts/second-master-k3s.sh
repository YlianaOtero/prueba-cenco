#!/bin/bash

# Set the IP address of the master server
export SERVER_IP=[IP SERVIDOR MASTER 0]

# Set the IP address of the next server
export NEXT_SERVER_IP=[IP SERVIDOR MASTER 2]

# Join the k3s cluster with the specified parameters
k3sup join --ip $NEXT_SERVER_IP --user $USER --server-user $USER --server-ip $SERVER_IP --server

echo "Server joined to the k3s cluster."
