provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web-server" {
  ami           = var.ami-id
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name = var.server1
  }
}
