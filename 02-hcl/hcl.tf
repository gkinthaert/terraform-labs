# terraform block
# allows only constants
# required_version specifies accepted version of Terraform for the project
#   Exact Version: required_version = "1.7.5" (Only v1.7.5 exactly).
#   Minimum Version: required_version = ">= 1.3.0" (v1.3.0 or any later version).
#   Pessimistic Constraint: required_version = "~> 1.7.5" (Allows v1.7.x patches, but not v1.8.0 or later).
#   Range Constraint: required_version = ">= 1.7.5, < 1.9.5" (Any version between these two bounds)
#   Exclude version: != 1.3.0

terraform {
    required_version = "~> 1.7" # latest version 1.14.8
    
    # backend block - used to configure a state backend for the project
    backend "s3" {

    }
    
    # required_providers specifies required providers for the project
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
      random = {
        source = "hashicorp/random"
        version = "~> 3.0"
      }
    }

}

# resource block managed by this script - bucket argument is set to variable defined later
resource "aws_s3_bucket" "my_bucket" {
    bucket = var.bucket_name
}

# data block for AWS S3 bucket managed EXTERNAL to terraform script
data "aws_s3_bucket" "my_external_bucket" {
    bucket = "not_managed_by_us"
}

# defining bucket name variable
variable "bucket_name" {
    type = string
    description = "my variable set to name the bucket"
    default = "my_default_bucket_name"
}

# defining an output block to output the id of the bucket
output "bucket_id" {
    value = aws_s3_bucket.my_bucket.id 
}

# defining a local block to create a local variable
locals {
  local_example = "This is a local variable"
}

# defining a module block that is to be included in a sub directory of the 
# directory we are currently working out of (not really created - example only)
module "my_module" {
    source = "./module_example"
}