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

resource "aws_iam_role_policy_attachment" "eks-cluster-policy-attach" {
  role = aws_iam_role.eks-cluster-role.name
  policy_arn = aws_iam_policy.eks-cluster-policy.arn
}

resource "aws_iam_policy" "eks-nodegroup-policy" {
  name = "nodegroup-policy"
  path = "/"
  description = "EKS nodegroup policy"

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

resource "aws_iam_role" "eks-nodegroup-role" {
  name = "nodegroup-role"

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

resource "aws_iam_role_policy_attachment" "eks-nodegroup-policy-attachment" {
  role = aws_iam_role.eks-nodegroup-role.name
  policy_arn = aws_iam_policy.eks-nodegroup-policy.arn
}


resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role = aws_iam_role.eks-nodegroup-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role = aws_iam_role.eks-nodegroup-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "container_registry_policy" {
  role = aws_iam_role.eks-nodegroup-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "eks-cluster" {
  name = "eks-test-cluster"

  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_a.id,
      aws_subnet.subnet_b.id
    ]
  }
}

resource "aws_eks_node_group" "eks-nodegroup" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  node_group_name = "eks-test"
  node_role_arn = aws_iam_role.eks-nodegroup-role.arn
  remote_access {
    ec2_ssh_key = var.eks-keypair
  }
  scaling_config {
    desired_size = 1
    max_size = 1
    min_size = 1
  }
  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]
}
