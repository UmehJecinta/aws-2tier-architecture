# create vpc
resource "aws_vpc" "aws_vpc" {
  cidr_block       = "14.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true


  tags = {
    Name = "aws_vpc"
  }
}

# create 2 public subnets
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.aws_vpc.id
  cidr_block = "14.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.aws_vpc.id
  cidr_block = "14.0.4.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet2"
  }
}

# create 2 private subnets
resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.aws_vpc.id
  cidr_block = "14.0.6.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.aws_vpc.id
  cidr_block = "14.0.8.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet2"
  }
}

# create internet gateway
resource "aws_internet_gateway" "aws_igw" {
  vpc_id = aws_vpc.aws_vpc.id

  tags = {
    Name = "aws_igw"
  }
}

# create elastic IP for Nat Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc" 
}

# create Nat Gateway
resource "aws_nat_gateway" "aws_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet1.id
  
  tags = {
    Name = "aws_nat"
  }
}

# create public route table
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.aws_vpc.id

  tags = {
    Name = "public_RT"
  }
}

# create private route table
resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.aws_vpc.id

  tags = {
    Name = "private_RT"
  }
}

# route public route table to internet gateway
resource "aws_route" "public-route" {
  route_table_id            = aws_route_table.public_RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.aws_igw.id
}

# route private route table to Nat gateway
resource "aws_route" "private-route" {
  route_table_id            = aws_route_table.private_RT.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id                = aws_nat_gateway.aws_nat.id
}

# associate route table with the public subnets
resource "aws_route_table_association" "public1_RTA_1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "public_RTA_2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_RT.id
}

# associate route table with the private subnets 
resource "aws_route_table_association" "private_RTA_1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "private_RTA_2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_RT.id
}
