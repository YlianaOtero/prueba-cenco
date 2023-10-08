#!/bin/bash

# Update and install PostgreSQL
sudo apt update
sudo apt install -y postgresql postgresql-contrib

# Start and enable PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Access PostgreSQL prompt as postgres user
sudo -u postgres psql <<EOF

-- Create a new database 'k3s'
CREATE DATABASE k3s;

-- Create a new user 'ubuntu' with password 'prueba-cenco'
CREATE USER ubuntu WITH ENCRYPTED PASSWORD 'prueba-cenco';

-- Set user permissions and configurations
ALTER ROLE ubuntu SET client_encoding TO 'utf8';
ALTER ROLE ubuntu SET default_transaction_isolation TO 'read committed';
ALTER ROLE ubuntu SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE k3s TO ubuntu;

EOF

# Configure PostgreSQL to allow remote connections
echo "host    k3s   ubuntu   0.0.0.0/0    md5" | sudo tee -a /etc/postgresql/12/main/pg_hba.conf

# Restart PostgreSQL service
sudo systemctl restart postgresql

echo "PostgreSQL setup completed."