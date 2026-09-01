# VPC
resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "Main-project-vpc"
  }
}

# subnet 1
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "Subnet1"
  }
}

# subnet 2
resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "Subnet2"
  }
}

# internet gateway
resource "aws_internet_gateway" "igw-main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet-gateway-for-main"
  }

}

# route table
resource "aws_route_table" "public-route-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-main.id
  }
  tags = {
    Name = "public route table"
  }
}

# route table associations

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public-route-rt.id

}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public-route-rt.id

}
