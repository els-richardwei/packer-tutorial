# packer-tutorial

## Problems

* amazon-ebs.ubuntu: VPCIdNotSpecified: No default VPC for this user

  Add VPC filter

  ```
  vpc_filter {
    filters = {
      "tag:Name": "SDMP-VPC-DEV",
      "isDefault": "false",
      "cidr": "10.131.229.0/24"
    }
  }
  ```

* amazon-ebs.ubuntu: Error launching source instance: a valid Subnet Id was not specified

  Add Subnet filter

  ```
  subnet_filter {
    filters = {
      "tag:Network Type": "Public"
      "random": true
    }
  }  
  ```

## Build an image

    `amazon-ebs.ubuntu: AMI: ami-09742a25c66a1002e`

## Provision

    `amazon-ebs.ubuntu: AMI: ami-0c9d91bd3329ec86d`

## Variables

    `amazon-ebs.ubuntu: AMI: ami-095d143ae80096db0`

## Parallel

    --> amazon-ebs.ubuntu: AMIs were created:
    cn-northwest-1: ami-0e5fc237496f86399

    --> amazon-ebs.ubuntu-focal: AMIs were created:
    cn-northwest-1: ami-04f25cfd989a8b7ed