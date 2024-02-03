provider "aws" {
  region = "ap-south-1"
}


variable "cidr" {
  default = "192.0.0.0/16"
}


resource "aws_key_pair" "hosting" {
  key_name   = "Manish-Key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_vpc" "hosting" {
  cidr_block = var.cidr
  tags = {
    Name = "hosting"
  }
}

resource "aws_subnet" "hosting" {
  vpc_id            = aws_vpc.hosting.id
  cidr_block        = "192.0.4.0/22"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hosting.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.hosting.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "websg" {
  subnet_id      = aws_subnet.hosting.id
  route_table_id = aws_route_table.RT.id
}


resource "aws_security_group" "hosting" {
  name   = "hosting"
  vpc_id = aws_vpc.hosting.id

  ingress {
    description = "HTTP from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "hosting-gw"
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "webhostingproject008"
}



resource "aws_instance" "Hosting" {
  ami           = "ami-05a5bb48beb785bf1"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.hosting.key_name
  tags = {
    Name = "hosting"
  }
  vpc_security_group_ids = [aws_security_group.hosting.id]
  subnet_id              = aws_subnet.hosting.id




  connection {
    type        = "ssh"
    user        = "ec2-user"                  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_ed25519") # Replace with the correct path to your private key
    host        = self.public_ip
  }
  # File provisioner to copy a file from local to the remote EC2 instance

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo yum update -y",                  # Update package lists (for ubuntu)
      "sudo su",
      "yum install httpd -y", # Example package installation
      "systemctl start httpd",
      "systemctl enable httpd",

    ]
  }
  provisioner "file" {
    source      = "index.html"                # Replace with the path to your local file
    destination = "/var/www/html/" # Replace with the path on the remote instance
  }
}

