terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}



resource "aws_instance" "this" {
  ami                     = "ami-05a5bb48beb785bf1"
  instance_type           = "t2.micro"
  tags = {
    Name = "Testing"
  }
}
