resource "google_compute_instance" "postgres_server" {
  name         = "postgresql-server"
  machine_type = "e2-medium" 
  zone         = "us-central1-a" 

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default" 

    access_config {}
  }

  tags = ["postgres"]
}