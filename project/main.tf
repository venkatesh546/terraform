provider "aws" {
    region = "us-east-1"
}

# Create a VPC 10.85.0.0/16
resource "aws_vpc" "venkatesh_vpc" {
    cidr_block = "10.85.0.0/16"
    tags = {
        Name = "venkatesh_vpc"
    }
}

# internet Gateway for VPC 
resource "aws_internet_gateway" "venkatesh_igw" {
    vpc_id = aws_vpc.venkatesh_vpc.id
    tags = {
        Name = "venkatesh_igw"
    }
  
}

#create a route table for publcic subnet
resource "aws_route_table" "venkatesh_rt" {
    vpc_id = aws_vpc.venkatesh_vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.venkatesh_igw.id
    }
    tags = {
      Name = "venkatesh_rt"
    }

    }

#create a public subnet 10.85.1.0/24
resource "aws_subnet" "venkatesh_sn" {
    vpc_id = aws_vpc.venkatesh_vpc.id
    cidr_block = "10.85.1.0/24"
    tags = {
        Name = "venkatesh_sn"

}
  }

 #associate route table with public subnet
    resource "aws_route_table_association" "venkatesh_rta" {
        subnet_id = aws_subnet.venkatesh_sn.id
        route_table_id = aws_route_table.venkatesh_rt.id    
    }
      
    # create a secutity group for EC2 instance
    resource "aws_security_group" "venkatesh-sg" {
        name = "venkatesh-sg"
        description = "Allow SSH and HTTP traffic"
        vpc_id = aws_vpc.venkatesh_vpc.id
         ingress  {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]


        }
        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]


        }
    }
      
   # create a network interface for EC2 instance
      resource "aws_network_interface" "venkatesh_eni" {
        subnet_id = aws_subnet.venkatesh_sn.id
        private_ips = ["10.85.1.10"]
        security_groups = [aws_security_group.venkatesh-sg.id]
        tags = {
            Name = "venkatesh_eni"
        }          
      }

   # create a elastic ip for EC2 instance
      resource "aws_eip" "venkatesh_eip" {
        network_interface = aws_network_interface.venkatesh_eni.id
        domain = "vpc"
        tags = {
            Name = "venkatesh_eip"
        }   
        
      }
    
    # create a EC2 instance in public subnet
    resource "aws_instance" "WebServer" {
  ami           = "ami-0c3389a4fa5bddaad"
  instance_type = "t3.micro"
  key_name      = "venkatkey"

network_interface {
    network_interface_id = aws_network_interface.venkatesh_eni.id
    device_index         = 0
  }
user_data = file("facebook.sh")
  tags = {
    Name = "Web1Server"
  }
}

output "web-server" {
        value = aws_eip.venkatesh_eip.public_ip
}





