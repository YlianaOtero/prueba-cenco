resource "aws_instance" "postgres_server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]

  tags = {
    Name = "postgresql-server"
  }
}