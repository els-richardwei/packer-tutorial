packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "cn-north-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source.
source "amazon-ebs" "firstrun-windows" {
  ami_name      = "packer-windows-demo-${local.timestamp}"
  communicator  = "winrm"
  instance_type = "t2.micro"
  region        = "${var.region}"
  source_ami_filter {
    filters = {
      # name                = "tio_base_win2016_standard-*"
      name                = "*Windows_Server-2016-English-Full-Base*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["016951021795"]
  }
  #vpc_filter {
  #  filters = {
  #    "tag:Name": "SDMP-VPC-DEV",
  #    "isDefault": "false",
  #    "cidr": "10.131.229.0/24"
  #  }
  #}
  #subnet_filter {
  #  filters = {
  #    "tag:Name": "SDMP.dev-backend.public_subnet*"
  #  }
  #  random = true
  #}  
  user_data_file = "./bootstrap_win.txt"
  associate_public_ip_address = true
  winrm_password = "SuperS3cr3t!!!!"
  winrm_username = "Administrator"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.firstrun-windows"]

  provisioner "powershell" {
    environment_vars = ["DEVOPS_LIFE_IMPROVER=PACKER"]
    inline           = ["Write-Host \"HELLO NEW USER; WELCOME TO $Env:DEVOPS_LIFE_IMPROVER\"", "Write-Host \"You need to use backtick escapes when using\"", "Write-Host \"characters such as DOLLAR`$ directly in a command\"", "Write-Host \"or in your own scripts.\""]
  }
  provisioner "windows-restart" {
  }
  provisioner "powershell" {
    environment_vars = ["VAR1=A$Dollar", "VAR2=A`Backtick", "VAR3=A'SingleQuote", "VAR4=A\"DoubleQuote"]
    script           = "./sample_script.ps1"
  }
}
