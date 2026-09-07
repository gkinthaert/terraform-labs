output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC created by Terraform"
}

output "vpc_arn" {
  value       = aws_vpc.main.arn
  description = "The ARN of the VPC created by Terraform"
}

output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "The CIDR block of the VPC created by Terraform"
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "route_table_id" {
  description = "ID of the main route table"
  value       = aws_route_table.main.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.example.id
}
