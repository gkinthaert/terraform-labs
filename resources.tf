# resources
resource "aws_instance" "regular_example_EC2" {
    ami = "ami-02f986bab3de34d0d"
    instance_type = "t3.micro"
    tags = {
        Name = "EC2=instance"
        Team = "Geert_Developers"
    }
}

variable "instance_type" {
    description = "The desired instance type"
    default = "t3.micro"
}

variable "ami" {
    description = "the desired AMI to use"
    default = "ami-02f986bab3de34d0d"
}

resource "aws_instance" "variable_EC2_example" {
    ami = var.ami
    instance_type = var.instance_type
}

# output
output "instance_id" {
    description = "the ID of the regular ec2 instance"
    value = aws_instance.regular_example_EC2.id
}

output "instance_id2" {
    description = "the ID of the variable ec2 instance"
    value = aws_instance.variable_EC2_example.id
}