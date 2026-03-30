provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "webvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "webvpc"
  }
}
resource "aws_internet_gateway" "webigw" {
  vpc_id = aws_vpc.webvpc.id
tags = {
  Name = "webigw"
}
}

resource "aws_subnet" "websn" {
  vpc_id = aws_vpc.webvpc.id
  cidr_block = var.subnet_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnt-web"
  
}
}

resource "aws_route_table"  "webrt" {
  vpc_id = aws_vpc.webvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webigw.id
  }
tags = {
  Name = "webrt"
}
}

resource "aws_route_table_association" "webrta" {
  subnet_id = aws_subnet.websn.id
  route_table_id = aws_route_table.webrt.id
} 

resource "aws_security_group" "websg" {
  name = "websg"
  description = "Allow HTTP and SSH traffic"
  vpc_id = aws_vpc.webvpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
  Name = "websg"
}
}

resource "aws_network_interface" "web-eni" {
  subnet_id = aws_subnet.websn.id
  private_ips = var.eni_pvt_ip
  security_groups = [aws_security_group.websg.id]

  tags = {
    
    name = "web-eni"
  }
}
resource "aws_eip" "WebEIP" {
  network_interface = aws_network_interface.web-eni.id
  domain = "vpc"
  tags = {
    Name = "WebEIP"
  }
}

resource "aws_instance" "webserver" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
 
  
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-eni.id
  }
  user_data = file("facebook.sh")
  tags = {
    Name = var.server_env
  }
}

output "webip" {
  value = aws_eip.WebEIP.public_ip
  }
  



