packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws"
  instance_type = "t2.micro"
  region        = "cn-northwest-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["837727238323"]
  }
  vpc_filter {
    filters = {
      "tag:Name": "SDMP-VPC-DEV",
      "isDefault": "false",
      "cidr": "10.131.229.0/24"
    }
  }
  subnet_filter {
    filters = {
      "tag:Name": "SDMP.dev-backend.public_subnet*"
    }
    random = true
  }  
  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}