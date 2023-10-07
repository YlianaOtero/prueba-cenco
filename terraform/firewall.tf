resource "google_compute_firewall" "k3s_nodes_fw" {
  name    = "k3s-nodes-fw"
  network = "default" # Change if you have a custom network

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "6443", "6444", "9090", "10250", "10255", "16443", "2379-2380", "4240", "30000-32767"]
  }

  allow {
    protocol = "udp"
    ports    = ["8472", "4789"]
  }

  source_ranges = ["10.128.0.0/20"]

  target_tags = ["k3s-nodes"]
}

resource "google_compute_firewall" "postgres_fw" {
  name    = "postgres-fw"
  network = "default" # Change if you have a custom network

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "5432"]
  }

  source_ranges = ["10.128.0.0/20"]

  target_tags = ["postgres"]
}

resource "google_compute_firewall" "default_egress_fw" {
  name    = "default-egress-fw"
  network = "default" # Change if you have a custom network

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["k3s-nodes", "postgres"]
}