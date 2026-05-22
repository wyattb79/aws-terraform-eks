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

resource "aws_iam_policy" "eks-cluster-policy" {
  name = "cluster-policy"
  path = "/"
  description = "EKS cluster policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "eks-cluster-role" {
  name = "cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-role-policy" {
  role = aws_iam_role.eks-cluster-role.name
  policy_arn = aws_iam_policy.eks-cluster-policy.arn
}

#resource "aws_eks_cluster" "eks-cluster" {
#  name = "eks-test-cluster"
#
#  vpc_config {
#    subnet_ids = [
#      aws_subnet.subnet_a.id,
#      aws_subnet.subnet_b.id
#    ]
#  }
#}
