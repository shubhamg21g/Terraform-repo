provider "aws" {
    profile = "terraform"
    region ="us-west-2"
}
/* -----------------vpc---------------- */

resource "aws_vpc" "mypvc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "mypvc"
  }
}

/* -------------public-subnet------------------ */

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.mypvc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.mypvc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public-subnet-2"
  }
}

/* ------------private-subnet------------ */

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.mypvc.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.mypvc.id
  cidr_block = "10.0.12.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "private-subnet-2"
  }
}

/* -------------igw--------------- */

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mypvc.id

  tags = {
    Name = "igw"
  }
}

/* -----------elastic-ip--------------- */

resource "aws_eip" "EIP" {
  vpc      = true
  tags = {
    Name = "myeip"
  }
}

/* -------------nat-gateway--------------- */

resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "NAT"
  }
 depends_on = [aws_internet_gateway.igw]
}

/* ------------route-table------------------ */

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.mypvc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.mypvc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT.id
  }
  tags = {
    Name = "private-rt"
  }
}

/* -----------subnet-association------------ */

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_instance" "webserver-public" {

  ami = "ami-0735c191cf914754d"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-subnet-1.id
}

resource "aws_instance" "webserver-pvt" {

  ami = "ami-0735c191cf914754d"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private-subnet-1.id
}
