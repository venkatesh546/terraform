resource "aws_instance" "server1" {
    ami = var.ami-id
    instance_type = var.instace_type
    key_name = var.key_name
    tags = {
      Name = var.Server1
    }
}