resource "google_compute_firewall" "k3s_nodes_fw" {
  name    = "k3s-nodes-fw"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "6443", "6444", "9090", "10250", "10255", "16443", "2379-2380", "4240", "30000-32767"]
  }

  allow {
    protocol = "udp"
    ports    = ["8472", "4789"]
  }

  source_ranges = [var.source_ip_range]

  target_tags = ["k3s-nodes"]
}

resource "google_compute_firewall" "postgres_fw" {
  name    = "postgres-fw"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "5432"]
  }

  source_ranges = [var.source_ip_range]

  target_tags = ["postgres"]
}

resource "google_compute_firewall" "default_egress_fw" {
  name    = "default-egress-fw"
  network = var.network_name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["k3s-nodes", "postgres"]
}