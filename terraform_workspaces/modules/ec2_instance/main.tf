provider "aws" {
  region = "ap-south-1"
}


variable "ami" {
    description = "This is AMI of the instance"
  
}
variable "instance_type" {
    description = "This is the type of the instance"
  
}

resource "aws_instance" "test" {
    ami = var.ami
    instance_type = var.instance_type

}
