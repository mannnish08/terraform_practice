provider "aws" {
  region = "ap-south-1"
}


variable "ami" {
    description = "This is AMI of the instance"
    type = map(string)

    default = {
      "dev" = "ami-03f4878755434977f" #Ubuntu
      "prod" = "ami-03f4878755434977f" #Ubuntu
      "stage" = "ami-05a5bb48beb785bf1"  #RedHat
    }
  
}
variable "instance_type" {
    description = "This is the type of the instance"
  
}

module "ec2_intance" {
    source = "./modules/ec2_instance"
    ami = lookup(var.ami, terraform.workspace, "ami-0d63de463e6604d0a")
    instance_type = var.instance_type
}