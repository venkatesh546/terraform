variable "ami-id" {
  description = "ami-value"
  default = "ami-0c3389a4fa5bddaad"
}

variable "instance_type" {
    description = "create instance in aws"
    default = "t3.micro"
}

variable "key_name" {
  
  description = "instance key on aws login"
  default = "venkatkey"
}

variable "server1" {
  
description = "instance web server"
default = "lab-webserver"
}

