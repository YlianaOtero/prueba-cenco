resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "google_compute_instance" "k3s_server" {
  count        = 2
  name         = "k3s-control-plane-${count.index + 1}"
  machine_type = "e2-medium" # Change to your desired machine type
  zone         = "us-central1-a" # Change to your desired zone

  

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default" # Change if you have a custom network

    // This will allocate an ephemeral external IP
    access_config {}
  }

  tags = ["k3s-nodes"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    curl -sLS https://get.k3sup.dev | INSTALL_K3S_EXEC='--flannel-backend=none --disable-network-policy' sh
    sudo cp k3sup /usr/local/bin/k3sup
    sudo install k3sup /usr/local/bin/
  EOF
}

resource "google_compute_instance" "k3s_worker" {
  count        = 2
  name         = "k3s-worker-${count.index + 1}"
  machine_type = "e2-medium" # Change to your desired machine type
  zone         = "us-central1-a" # Change to your desired zone

  

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default" # Change if you have a custom network

    // This will allocate an ephemeral external IP
    access_config {}
  }

  tags = ["k3s-nodes"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    curl -sLS https://get.k3sup.dev | INSTALL_K3S_EXEC='--flannel-backend=none --disable-network-policy' sh
    sudo cp k3sup /usr/local/bin/k3sup
    sudo install k3sup /usr/local/bin/
  EOF
}

resource "google_compute_instance" "postgres_server" {
  name         = "postgres-server"
  machine_type = "e2-medium" # Change to your desired machine type
  zone         = "us-central1-a" # Change to your desired zone

  

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default" # Change if you have a custom network

    // This will allocate an ephemeral external IP
    access_config {}
  }

  tags = ["postgres"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt install -y postgresql postgresql-contrib
    sudo systemctl start postgresql
    sudo systemctl enable postgresql

    sudo -u postgres psql <<-SQL
      CREATE DATABASE k3s;
      CREATE USER ubuntu WITH ENCRYPTED PASSWORD 'prueba-cenco';
      ALTER ROLE ubuntu SET client_encoding TO 'utf8';
      ALTER ROLE ubuntu SET default_transaction_isolation TO 'read committed';
      ALTER ROLE ubuntu SET timezone TO 'UTC';
      GRANT ALL PRIVILEGES ON DATABASE k3s TO ubuntu;
    SQL

    echo "host    k3s   ubuntu   0.0.0.0/0    md5" | sudo tee -a /etc/postgresql/12/main/pg_hba.conf
    sudo systemctl restart postgresql
  EOF
}

