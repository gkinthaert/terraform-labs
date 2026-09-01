provider "aws" {
  region = "us-east-2"
}

locals {
  common_tags = {
    FolderName  = "06-resources"
    ManagedBy   = "Terraform"
    Project     = "06-resources"
    Team        = "G. Kinthaert"
    Environment = "Test"
  }
}

resource "aws_vpc" "poc_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = merge(local.common_tags, {
    Name = "06-resources-vpc"
  })
}
# public subnets
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.poc_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2a"
  tags = merge(local.common_tags, {
    Name = "06-resources-public-sn1"
  })
}

resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.poc_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-2b"
     tags = merge(local.common_tags, {
    Name = "06-resources-public-sn2"
  })
}
# private subnets
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.poc_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  tags = merge(local.common_tags, {
    Name = "06-resources-private-sn1"
  })
}

resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.poc_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-2b"
     tags = merge(local.common_tags, {
    Name = "06-resources-private-sn2"
  })
  }

# internet gateway for the public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.poc_vpc.id
  tags = merge(local.common_tags, {
    Name = "06-resources-igw"
  })
}

# NAT gateway (in primary public subnet for private subnet egress)

# set up EIP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = merge(local.common_tags, {
    Name = "06-resources-nat-eip"
  })
}
# NAT gateway just set up for the public subnet on the first AZ
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id
  tags = merge(local.common_tags, {
    Name = "06-resources-nat-gw"
  })
  depends_on = [aws_internet_gateway.igw]
}

# public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.poc_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.common_tags, { Name = "06-resources-public-rt"
  })
}

resource "aws_route_table_association" "public_rt_assoc-1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rt.id
}

# private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.poc_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(local.common_tags, {
    Name = "06-resources-private-rt"
  })
}

resource "aws_route_table_association" "private_rt_assoc1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}