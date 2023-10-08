#!/bin/bash

set -e  

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

install_postgresql_client() {
  apt-get update
  apt install -y postgresql-client
}

get_postgresql_version() {
  postgres_version=$(psql --version | awk '{print $3}' | cut -d'.' -f1)
  echo "Detected PostgreSQL major version: $postgres_version"
}

read -p "Enter the IP address of the master server: " MASTER_SERVER_IP
read -p "Enter the username for the database: " DB_USER
read -sp "Enter the password for the database user '$DB_USER': " DB_PASSWORD
echo
read -p "Enter the IP address of the database server: " DB_SERVER_IP

DATASTORE_ENDPOINT="postgres://$DB_USER:$DB_PASSWORD@$DB_SERVER_IP:5432/k3s"
K3S_TOKEN=$(head -c 16 /dev/urandom | shasum | cut -d" " -f1)

install_k3s() {
  k3sup install --ip $MASTER_SERVER_IP --user $USER --token $K3S_TOKEN --datastore $DATASTORE_ENDPOINT --cluster
}

export KUBECONFIG=/home/ubuntu/kubeconfig

switch_to_default_context() {
  kubectl config use-context default
}

main() {
  install_postgresql_client
  get_postgresql_version
  install_k3s
  switch_to_default_context
}

main