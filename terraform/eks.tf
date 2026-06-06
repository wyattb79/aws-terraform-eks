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
