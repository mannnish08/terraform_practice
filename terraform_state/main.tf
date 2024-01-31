
provider "aws" {
    region = "ap-south-1"
  
}

resource "aws_instance" "example" {
    instance_type = "t2.micro"
    ami = "ami-05a5bb48beb785bf1"
    tags = {
        Name = "Backend"
    }

}


resource "aws_s3_bucket" "s3_bucket" {
    bucket = "backendtestting0008"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


