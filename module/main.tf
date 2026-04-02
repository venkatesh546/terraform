provider "aws" {
    region = "us-east-1"
}

module "ec2instance" {
    source = "./ec2-module"
    ami-id = "ami-0c3389a4fa5bddaad"
    instace_type = "t3.micro"
    key_name = "venkatkey"
    Server1 = "webServer"
}
