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
          Service = "eks.amazonaws.com"
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

resource "aws_iam_role_policy_attachment" "nodegroup-required-policies-attachment" {
  for_each = toset(local.node_group_policies)
  role = aws_iam_role.eks-nodegroup-role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "cluster-required-policies-attachment" {
  for_each = toset(local.cluster_policies)
  role = aws_iam_role.eks-cluster-role.name
  policy_arn = each.value
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

resource "aws_iam_role" "karpenter_sa_role" {
  name = "karpenter-sa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}
