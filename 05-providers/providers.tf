terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-east-2"
  alias  = "ohio" #alias to be used to select another provider for a resource.  If there is no alias that provider will be the default provider
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "us-east-1-some-random-bucket-name-43983749"
}

resource "aws_s3_bucket" "my_bucket2" {
  bucket   = "us-east-1-some-random-bucket-name-43987933lk"
  provider = aws.ohio
}