resource "aws_instance" "k3s_server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.k3s_nodes_sg.id]

  count = 3

  tags = {
    Name = "k3s-control-plane-${count.index + 1}"
  }
}

resource "aws_instance" "k3s_worker" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"  
  
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.k3s_nodes_sg.id]

  count = 2  

  tags = {
    Name = "k3s-worker-${count.index + 1}"
  }
}

resource "aws_instance" "postgres_server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]

  tags = {
    Name = "postgre-server"
  }
}