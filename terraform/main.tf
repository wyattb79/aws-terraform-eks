resource "aws_vpc" "eks-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id = aws_vpc.eks-vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "subnet_b" {
  vpc_id = aws_vpc.eks-vpc.id
  cidr_block = "10.0.2.0/24"
}
