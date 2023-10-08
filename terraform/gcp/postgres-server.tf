resource "google_compute_instance" "postgres_server" {
  name         = "postgresql-server"
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

  tags = ["postgres"]
}