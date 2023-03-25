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

resource "aws_subnet" "akvpc-PublicSubnet-1" {
  vpc_id = aws_vpc.ak-vpc.id
  availability_zone = var.AZ-1
  cidr_block = "10.10.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "akvpc-PublicSubnet-1"
  }
}

resource "aws_subnet" "akvpc-PrivateSubnet-1" {
    vpc_id = aws_vpc.ak-vpc.id
    availability_zone = var.AZ-1
    cidr_block = "10.10.1.0/24"
    map_public_ip_on_launch = false

    tags = {
        "Name" = "akvpc-PrivateSubnet-1"
    }
  
}

resource "aws_subnet" "akvpc-PublicSubnet-2" {
  vpc_id = aws_vpc.ak-vpc.id
  availability_zone = var.AZ-2
  cidr_block = "10.10.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "akvpc-PublicSubnet-2"
  }
}

resource "aws_subnet" "akvpc-PrivateSubnet-2" {
  vpc_id = aws_vpc.ak-vpc.id
  availability_zone = var.AZ-2
  cidr_block = "10.10.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    "Name" = "akvpc-PrivateSubnet-2"
  }
}

resource "aws_subnet" "akvpc-PublicSubnet-3" {
  vpc_id = aws_vpc.ak-vpc.id
  availability_zone = var.AZ-3
  cidr_block = "10.10.4.0/24"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "akvpc-PublicSubnet-3"
  }
}

resource "aws_subnet" "akvpc-PrivateSubnet-3" {
  vpc_id = aws_vpc.ak-vpc.id
  availability_zone = var.AZ-3
  cidr_block = "10.10.5.0/24"

  tags = {
    "Name" = "akvpc-PrivateSubnet-3"
  }
}

resource "aws_internet_gateway" "akvpc-IGW" {
  vpc_id = aws_vpc.ak-vpc.id

  tags = {
    "Name" = "akvpc-IGW"
  }
}

# resource "aws_internet_gateway_attachment" "akpc-IGW-attach" {
#   internet_gateway_id = aws_internet_gateway.akvpc-IGW.id
#   vpc_id = aws_vpc.ak-vpc.id
# }

resource "aws_route_table" "akvpc-PublicRT" {
  vpc_id = aws_vpc.ak-vpc.id

  tags = {
    "Name" = "akvpc-PublicRT"
  }
}

resource "aws_route_table" "akvpc-PrivateRT" {
  vpc_id = aws_vpc.ak-vpc.id

  tags = {
    "Name" = "akvpc-PrivateRT"
  }
}

resource "aws_route" "akvpc-IGW-Route" {
  route_table_id = aws_route_table.akvpc-PublicRT.id
  gateway_id = aws_internet_gateway.akvpc-IGW.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "akvpc-PublicRT-Assc" {
  subnet_id = aws_subnet.akvpc-PublicSubnet-1.id
  route_table_id = aws_route_table.akvpc-PublicRT.id
}

resource "aws_route_table_association" "akvpc-PrivateRT-Assc" {
  route_table_id = aws_route_table.akvpc-PrivateRT.id
  subnet_id = aws_subnet.akvpc-PrivateSubnet-3.id
}

resource "aws_route_table_association" "akvpc-PublicSubnet1-Assc" {
  route_table_id = aws_route_table.akvpc-PublicRT.id
  subnet_id = aws_subnet.akvpc-PublicSubnet-1.id
}

resource "aws_route_table_association" "akvpc-PublicSubnet2-Assc" {
  route_table_id = aws_route_table.akvpc-PublicRT.id
  subnet_id = aws_subnet.akvpc-PublicSubnet-2.id
}

resource "aws_route_table_association" "akvpc-PublicSubnet3-Assc" {
  route_table_id = aws_route_table.akvpc-PublicRT.id
  subnet_id = aws_subnet.akvpc-PublicSubnet-3.id
}

resource "aws_route_table_association" "akvpc-PrivateSubnet1-Assc" {
  route_table_id = aws_route_table.akvpc-PrivateRT.id
  subnet_id = aws_subnet.akvpc-PrivateSubnet-1.id
}

resource "aws_route_table_association" "akvpc-PrivateSubnet2-Assc" {
  route_table_id = aws_route_table.akvpc-PrivateRT.id
  subnet_id = aws_subnet.akvpc-PrivateSubnet-2.id
}

resource "aws_route_table_association" "akvpc-PrivateSubnet3-Assc" {
  route_table_id = aws_route_table.akvpc-PrivateRT.id
  subnet_id = aws_subnet.akvpc-PrivateSubnet-3.id
}

resource "aws_eip" "akvpc-NGW-EIP" {
  tags = {
    "Name" = "akvpc-NGW-EIP"
  }
}

resource "aws_nat_gateway" "akvpc-NGW" {
  subnet_id = aws_subnet.akvpc-PublicSubnet-1.id
  allocation_id = aws_eip.akvpc-NGW-EIP.id

  tags = {
    "Name" = "akvpc-NGW"
  }
}

resource "aws_route" "akvpc-NGW-Route" {
  route_table_id = aws_route_table.akvpc-PrivateRT.id
  gateway_id = aws_nat_gateway.akvpc-NGW.id
  destination_cidr_block = "0.0.0.0/0"
}