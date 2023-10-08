#!/bin/bash

set -e  

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

install_postgresql() {
  echo "Updating and installing PostgreSQL..."
  apt update
  apt install -y postgresql postgresql-contrib
}

get_postgresql_version() {
  postgres_version=$(pg_config --version | awk '{print $2}' | cut -d'.' -f1)
  echo "Detected PostgreSQL major version: $postgres_version"
}

configure_postgresql() {
  read -p "Enter a username for the database: " db_user
  read -sp "Enter a password for the database user '$db_user': " db_password

  echo -e "\nConfiguring PostgreSQL..."
  sudo -u postgres psql <<EOF
CREATE DATABASE k3s;
CREATE USER $db_user WITH ENCRYPTED PASSWORD '$db_password';
ALTER ROLE $db_user SET client_encoding TO 'utf8';
ALTER ROLE $db_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE $db_user SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE k3s TO $db_user;
EOF
}

allow_remote_connections() {
  echo "Configuring PostgreSQL for remote connections..."
  echo "host    k3s   $db_user   0.0.0.0/0    md5" | sudo tee -a /etc/postgresql/$postgres_version/main/pg_hba.conf
}

update_listen_address() {
  echo "Updating listen_address in postgresql.conf..."
  echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/$postgres_version/main/postgresql.conf
  sudo systemctl restart postgresql
}

main() {
  install_postgresql
  get_postgresql_version
  configure_postgresql
  allow_remote_connections
  update_listen_address
  echo "PostgreSQL setup completed."
}

main