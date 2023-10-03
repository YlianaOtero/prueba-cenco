provider "aws" {
  region = "us-east-1" 
  profile = "default"
}

resource "aws_instance" "k3s_server" {
  ami           = "ami-03a6eaae9938c858c"
  instance_type = "t2.micro"

  count = 3 

  tags = {
    Name = "k3s-control-plane-${count.index + 1}"
  }
}

resource "aws_instance" "k3s_worker" {
  ami           = "ami-03a6eaae9938c858c"
  instance_type = "t2.micro"  

  count = 2  

  tags = {
    Name = "k3s-worker-${count.index + 1}"
  }
}