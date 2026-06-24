locals {
  cluster_policies = [
    "arn:${var.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
  node_group_policies = [
    "arn:${var.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:${var.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:${var.partition}:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}
