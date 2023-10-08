variable "source_ip_range" {
  description = "Source IP range for the firewall rules"
  default     = "0.0.0.0/0"
}

resource "aws_security_group" "k3s_nodes_sg" {
  name        = "k3s_nodes_sg"
  description = "Security group for k3s nodes"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 6444 
    to_port     = 6444
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 8472 
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 9090 
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 10250 
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 10255 
    to_port     = 10255
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 16443
    to_port     = 16443
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 2379 
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 4240 
    to_port     = 4240
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 4789 
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = [var.source_ip_range]
  }

  ingress {
    from_port   = 30000 
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "postgres_sg" {
  name        = "postgres_sg"
  description = "Security group for PostgreSQL"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.source_ip_range]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

}