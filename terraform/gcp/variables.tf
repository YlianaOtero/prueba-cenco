variable "network_name" {
  description = "Name of the network"
  default     = "default"
}

variable "source_ip_range" {
  description = "Source IP range for the firewall rules"
  default     = "10.128.0.0/20"
}