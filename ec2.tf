# EC2 Server Setup - Web App Hosting
resource "aws_instance" "ecomm-server" {
  ami           = "ami-0430580de6244e02e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.ecomm-subnet.id
  key_name = "ravi-key"
  vpc_security_group_ids = [aws_security_group.ecomm-sg.id]
  tags = {
    Name = "ecomm-server"
  }
}