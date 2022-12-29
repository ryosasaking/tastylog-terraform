#-------------------------------
# VPC
#-------------------------------

resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    project = var.project
    Env     = var.environment

  }

}

#-------------------------------
# Subnet
#-------------------------------

resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1a"
    project = var.project
    Env     = var.environment
    Type    = "public"

  }

}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1c"
    project = var.project
    Env     = var.environment
    Type    = "public"

  }

}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1a"
    project = var.project
    Env     = var.environment
    Type    = "private"

  }

}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1c"
    project = var.project
    Env     = var.environment
    Type    = "private"

  }

}
#-------------------------------
# Route-Table
#-------------------------------
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-public-rt"
    project = var.project
    Env     = var.environment
    Type    = "public"
  }


}
resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id

}
resource "aws_route_table_association" "public_rt_1c" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public_subnet_1c.id

}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-rt"
    project = var.project
    Env     = var.environment
    Type    = "private"
  }


}
resource "aws_route_table_association" "private_rt_1a" {
  route_table_id = aws_route_table.private-rt.id
  subnet_id      = aws_subnet.private_subnet_1a.id

}
resource "aws_route_table_association" "private_rt_1c" {
  route_table_id = aws_route_table.private-rt.id
  subnet_id      = aws_subnet.private_subnet_1c.id

}

#-------------------------------
# Internet Gateway
#-------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    project = var.project
    Env     = var.environment
  }


}
resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public-rt.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"

}
