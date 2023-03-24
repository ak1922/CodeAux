provider "aws" {
region = "us-east-1"
}

resource "aws_vpc" "ak-vpc" {
    cidr_block = "10.10.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "ak_vpc"
    }
  
}