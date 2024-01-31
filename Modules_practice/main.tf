provider "aws" {
  region = "ap-south-1"
}


module "ec2_instance" {
  source = "./module/ec2_instance"
  ami_value = "ami-05a5bb48beb785bf1"
  instance_type_value = "t2.micro"
  subnet_id_value = "subnet-0b98c0e07332462d1"
  
}
