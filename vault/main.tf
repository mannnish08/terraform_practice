provider "aws" {
  region = "ap-south-1"

}

provider "vault" {
  address          = "http://13.233.90.194:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "d256bb70-cdab-f7c4-3580-7544330f7d2b"
      secret_id = "b5cc1fad-d42f-a4d8-b356-2d20860a2866"
    }
  }
}


data "vault_kv_secret_v2" "example" {
  mount = "secret_kv"   // change it according to your mount
  name  = "test-secret" // change it according to your secret
}


resource "aws_instance" "name" {
  ami           = "ami-05a5bb48beb785bf1"
  instance_type = "t2.micro"
  tags = {
    Name = "Testing"
    secret = data.vault_kv_secret_v2.example.data["username"]
  }

}
