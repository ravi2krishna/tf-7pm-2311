# VPC Components
resource "aws_vpc" "ecomm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ecomm"
  }
}

# Subnet
resource "aws_subnet" "ecomm-subnet" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "ecomm-subnet"
  }
}

# Gateway
resource "aws_internet_gateway" "ecomm-gw" {
  vpc_id = aws_vpc.ecomm-vpc.id

  tags = {
    Name = "ecomm-gateway"
  }
}

# Route Table
resource "aws_route_table" "ecomm-rt" {
  vpc_id = aws_vpc.ecomm-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecomm-gw.id
  }

  tags = {
    Name = "ecomm-route-table"
  }
}

# Subnet Association - RT
resource "aws_route_table_association" "ecomm-asc" {
  subnet_id      = aws_subnet.ecomm-subnet.id
  route_table_id = aws_route_table.ecomm-rt.id
}

# Network Access Control List - NACL
resource "aws_network_acl" "ecomm-nacl" {
  vpc_id = aws_vpc.ecomm-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ecomm-nacl"
  }
}

# NACL - Subnet Association
resource "aws_network_acl_association" "nacl-asc" {
  network_acl_id = aws_network_acl.ecomm-nacl.id
  subnet_id      = aws_subnet.ecomm-subnet.id
}

# Security Group
resource "aws_security_group" "ecomm-sg" {
  name        = "ecomm-sg"
  description = "Allow ecomm inbound traffic"
  vpc_id      = aws_vpc.ecomm-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecomm-security-group"
  }
}