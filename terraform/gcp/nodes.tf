resource "google_compute_instance" "k3s_server" {
  count        = 3
  name         = "k3s-control-plane-node-${count.index + 1}"
  machine_type = "e2-medium" 
  zone         = "us-central1-a" 

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = var.network_name

    access_config {}
  }

  tags = ["k3s-nodes"]
}

resource "google_compute_instance" "k3s_worker" {
  count        = 2
  name         = "k3s-worker-node-${count.index + 1}"
  machine_type = "e2-medium" 
  zone         = "us-central1-a" 

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = var.network_name

    access_config {}
  }

  tags = ["k3s-nodes"]
}

