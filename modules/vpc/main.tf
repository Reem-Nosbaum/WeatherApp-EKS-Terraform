resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name    = "development-vpc"
    Project = var.project_tag
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.public_subnet_cidr_1
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name    = "dev-public-subnet-1"
    Project = var.project_tag
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.public_subnet_cidr_2
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true
  tags = {
    Name    = "dev-public-subnet-2"
    Project = var.project_tag
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.private_subnet_cidr_1
  availability_zone = "${var.region}a"
  tags = {
    Name    = "dev-private-subnet-1"
    Project = var.project_tag
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.private_subnet_cidr_2
  availability_zone = "${var.region}b"
  tags = {
    Name    = "dev-private-subnet-2"
    Project = var.project_tag
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name    = "dev-IGW"
    Project = var.project_tag
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name    = "NAT-GW"
    Project = var.project_tag
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name    = "NAT-GW-Public-IP"
    Project = var.project_tag
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name    = "Public-RT"
    Project = var.project_tag
  }
}

resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name    = "Private-RT"
    Project = var.project_tag
  }
}

resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "sg_vpc_endpoints" {
  name        = "vpc-endpoints-sg"
  description = "Security group for VPC endpoints allowing HTTPS traffic from private subnet only"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "Allow HTTPS from private subnet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr_1, var.private_subnet_cidr_2]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoints-sg"
    Project = var.project_tag
  }
}
