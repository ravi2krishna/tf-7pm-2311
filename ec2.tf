# EC2 Server Setup - A - AZ - Web App Hosting
resource "aws_instance" "ecomm-server-a" {
  ami           = "ami-0430580de6244e02e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.ecomm-pub-subnet-a.id
  key_name = "ravi-key"
  vpc_security_group_ids = [aws_security_group.ecomm-pub-sg.id]
  user_data = file("ecomm.sh")
  tags = {
    Name = "ecomm-server-a"
  }
}

# EC2 Server Setup - B - AZ - Web App Hosting
resource "aws_instance" "ecomm-server-b" {
  ami           = "ami-0430580de6244e02e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.ecomm-pub-subnet-b.id
  key_name = "ravi-key"
  vpc_security_group_ids = [aws_security_group.ecomm-pub-sg.id]
  user_data = file("ecomm.sh")
  tags = {
    Name = "ecomm-server-b"
  }
}


# EC2 Server Setup - A - AZ - DB App Hosting
resource "aws_instance" "ecomm-server-db-a" {
  ami           = "ami-0430580de6244e02e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.ecomm-pvt-subnet-a.id
  key_name = "ravi-key"
  vpc_security_group_ids = [aws_security_group.ecomm-pvt-sg.id]
  tags = {
    Name = "ecomm-server-db-a"
  }
}