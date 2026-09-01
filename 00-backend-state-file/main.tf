# terraform configuration
terraform {
  required_version = "~> 1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "grk-state-file-bucket-location" # needs to be created in advance
    key    = "global/s3/terraform.tfstate"
    region = "us-east-2" # could be any region
    # dynamodb_table = "grk-tf-table"  # deprecated - used for statelocking
    use_lockfile = true # state locking can now be done natively in S3

  }
}
# provider and default region
provider "aws" {
  region = "us-east-2"

}