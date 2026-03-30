variable "vpc_cidr" {
  description = "vpc_value"
  default = "10.81.0.0/16"
}

variable "subnet_cidr" {
  description = "subnet for instance"
  default = "10.81.1.0/24"
}

variable "eni_pvt_ip" {
  description = "network interface ip"
  default = ["10.81.1.10"]
  }

  variable "ami" {
    description = "ami for instance"
    default = "ami-0c3389a4fa5bddaad"
  }

  variable "instance_type" {
    description = "instance type"
    default = "t3.micro"
  }

  variable "key_name" {
    description = "key pair name"
    default = "venkatkey"
}

variable "server_env" {
    description = "server name for instance"
  default = "webserver"
}

variable "server_count" {
    description = "Number of ec2 instance"
    default = 2  
}
