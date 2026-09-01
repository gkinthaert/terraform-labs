# initializing Terraform config
terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 6.39.0"
      }
    }
}

# selecting the provider and the AWS region to be used
provider "aws" {
    region = "us-east-2"
}

#resource section

# create the VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Terraform VPC"
  }
}

# create the subnets

# public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = "10.0.0.0/24"
}

# private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = "10.0.1.0/24"
}

# internet gateway
resource "aws_internet_gateway" "demo_igw" {
    vpc_id = aws_vpc.demo_vpc.id
}

# route table for public subnet
resource "aws_route_table" "public_subnet_rtb" {
    vpc_id = aws_vpc.demo_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo_igw.id
    }
}

# route table association for public subnet
resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.public_subnet_rtb.id 
}