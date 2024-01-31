terraform {
  backend "s3" {
    bucket = "backendtestting0008"
    key    = "manis/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    dynamodb_table = "terraform_lock"
  }
}
