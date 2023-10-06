# VPC Components
resource "aws_vpc" "ecomm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ecomm"
  }
}

# Public Subnet - AZ - A
resource "aws_subnet" "ecomm-pub-subnet-a" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "ecomm-pub-subnet-A"
  }
}

# Public Subnet - AZ - B
resource "aws_subnet" "ecomm-pub-subnet-b" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "ecomm-pub-subnet-B"
  }
}

# Private Subnet - AZ - A
resource "aws_subnet" "ecomm-pvt-subnet-a" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "ecomm-pvt-subnet-A"
  }
}

# Private Subnet - AZ - B
resource "aws_subnet" "ecomm-pvt-subnet-b" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "ecomm-pvt-subnet-B"
  }
}

# Gateway
resource "aws_internet_gateway" "ecomm-gw" {
  vpc_id = aws_vpc.ecomm-vpc.id

  tags = {
    Name = "ecomm-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "ecomm-pub-rt" {
  vpc_id = aws_vpc.ecomm-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecomm-gw.id
  }

  tags = {
    Name = "ecomm-public-route-table"
  }
}

# Private Route Table
resource "aws_route_table" "ecomm-pvt-rt" {
  vpc_id = aws_vpc.ecomm-vpc.id

  tags = {
    Name = "ecomm-private-route-table"
  }
}

# Pub Subnet A Association - RT
resource "aws_route_table_association" "ecomm-pub-asc-a" {
  subnet_id      = aws_subnet.ecomm-pub-subnet-a.id
  route_table_id = aws_route_table.ecomm-pub-rt.id
}

# Pub Subnet B Association - RT
resource "aws_route_table_association" "ecomm-pub-asc-b" {
  subnet_id      = aws_subnet.ecomm-pub-subnet-b.id
  route_table_id = aws_route_table.ecomm-pub-rt.id
}

# Pvt Subnet A Association - RT
resource "aws_route_table_association" "ecomm-pvt-asc-a" {
  subnet_id      = aws_subnet.ecomm-pvt-subnet-a.id
  route_table_id = aws_route_table.ecomm-pvt-rt.id
}

# Pvt Subnet B Association - RT
resource "aws_route_table_association" "ecomm-pvt-asc-b" {
  subnet_id      = aws_subnet.ecomm-pvt-subnet-b.id
  route_table_id = aws_route_table.ecomm-pvt-rt.id
}

# Public Network Access Control List - NACL
resource "aws_network_acl" "ecomm-pub-nacl" {
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
    Name = "ecomm-public-nacl"
  }
}


# Private Network Access Control List - NACL
resource "aws_network_acl" "ecomm-pvt-nacl" {
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
    Name = "ecomm-private-nacl"
  }
}

# Public - NACL - Subnet - A - Association
resource "aws_network_acl_association" "pub-nacl-asc-a" {
  network_acl_id = aws_network_acl.ecomm-pub-nacl.id
  subnet_id      = aws_subnet.ecomm-pub-subnet-a.id
}

# Public - NACL - Subnet - B - Association
resource "aws_network_acl_association" "pub-nacl-asc-b" {
  network_acl_id = aws_network_acl.ecomm-pub-nacl.id
  subnet_id      = aws_subnet.ecomm-pub-subnet-b.id
}

# Private - NACL - Subnet - A - Association
resource "aws_network_acl_association" "pvt-nacl-asc-a" {
  network_acl_id = aws_network_acl.ecomm-pvt-nacl.id
  subnet_id      = aws_subnet.ecomm-pvt-subnet-a.id
}

# Private - NACL - Subnet - B - Association
resource "aws_network_acl_association" "pvt-nacl-asc-b" {
  network_acl_id = aws_network_acl.ecomm-pvt-nacl.id
  subnet_id      = aws_subnet.ecomm-pvt-subnet-b.id
}

# Public Security Group
resource "aws_security_group" "ecomm-pub-sg" {
  name        = "pub-ecomm-sg"
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
    Name = "ecomm-pub-security-group"
  }
}

# Private Security Group
resource "aws_security_group" "ecomm-pvt-sg" {
  name        = "pvt-ecomm-sg"
  description = "Allow ecomm inbound traffic"
  vpc_id      = aws_vpc.ecomm-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
  }

  ingress {
    description      = "MySQL"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecomm-pvt-security-group"
  }
}