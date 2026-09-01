resource "aws_instance" "web_server" {
  ami                         = "ami-02f986bab3de34d0d"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public1.id
  vpc_security_group_ids      = [aws_security_group.public_http_traffic.id]
  # the root block info is not really needed but 
  # this is what it looks like if you want to define
  # your EBS volumes
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }
  tags = merge(local.common_tags, {
    Name = "06-resources-webserver"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "public_http_traffic" {
  description = "security group allowing http and https traffic"
  name        = "public_http_traffic"
  vpc_id      = aws_vpc.poc_vpc.id

  tags = merge(local.common_tags, {
    Name = "06-resources-securitygroup"
  })

}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
