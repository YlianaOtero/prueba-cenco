resource "aws_security_group" "security_group" {
  name        = "security-group"
  description = "Security group for k3s cluster"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

resource "aws_instance" "k3s_server" {
  ami           = "ami-03a6eaae9938c858c"
  instance_type = "t2.micro"
  key_name      = "instance-keys"

  security_group_names = [aws_security_group.security_group.name]

  count = 1

  tags = {
    Name = "k3s-control-plane-${count.index + 1}"
  }
}

resource "aws_instance" "k3s_worker" {
  ami           = "ami-03a6eaae9938c858c"
  instance_type = "t2.micro"  
  key_name      = "instance-keys"

  security_group_names = [aws_security_group.security_group.name]

  count = 1  

  tags = {
    Name = "k3s-worker-${count.index + 1}"
  }
}