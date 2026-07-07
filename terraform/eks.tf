resource "aws_eks_cluster" "eks-cluster" {
  name = "eks-test-cluster"

  version = "${var.tf-version}"

  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access = false

    security_group_ids = [aws_security_group.eks_cluster_sg.id]

    subnet_ids = [
      aws_subnet.subnet_a.id,
      aws_subnet.subnet_b.id
    ]
  }

  access_config {
    authentication_mode = "API"
  }

  depends_on = [
    aws_vpc_endpoint.eks-ec2-endpoint,
    aws_vpc_endpoint.eks-auth-endpoint,
    aws_vpc_endpoint.eks-ecrapi-endpoint,
    aws_vpc_endpoint.eks-ecrdkr-endpoint,
    aws_vpc_endpoint.eks-s3-endpoint
  ]
}

//resource "aws_eks_node_group" "eks-nodegroup" {
//  cluster_name = aws_eks_cluster.eks-cluster.name
//  node_group_name = "eks-nodegroup"
//  node_role_arn = aws_iam_role.eks-nodegroup-role.arn
//
//  scaling_config {
//    desired_size = 1
//    max_size = 1
//    min_size = 1
//  }
//
//  subnet_ids = [
//    aws_subnet.subnet_a.id,
//    aws_subnet.subnet_b.id
//  ]
//
//  ami_type = "AL2023_x86_64_STANDARD"
//  capacity_type = "ON_DEMAND"
//
//  instance_types = ["t3.medium"]
//  launch_template {
//    id = aws_launch_template.eks-node-template.id
//    version = aws_launch_template.eks-node-template.latest_version
//  }
//
//  depends_on = [
//    aws_iam_role_policy_attachment.nodegroup-required-policies-attachment
//  ]
//}

resource "aws_eks_addon" "vpc_cni_plugin" {
  addon_name = "vpc-cni"
  cluster_name = aws_eks_cluster.eks-cluster.name
}

resource "aws_launch_template" "eks-node-template" {
  name = "eks-node-template"
  description = "Launch template for EKS Node group"

  key_name = var.eks-keypair

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [
      aws_security_group.eks_nodegroup_sg.id
    ]
  }
}

resource "aws_eks_access_entry" "eks_admins" {
  for_each = toset([for obj in data.aws_iam_group.eks_admins.users: obj.arn])

  cluster_name = resource.aws_eks_cluster.eks-cluster.name
  principal_arn = each.value
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_admin_policies" {
  for_each = toset([for obj in data.aws_iam_group.eks_admins.users: obj.arn])

  cluster_name = resource.aws_eks_cluster.eks-cluster.name
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = each.value

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_addon" "pod_identity_agent" {
  addon_name = "eks-pod-identity-agent"
  cluster_name = aws_eks_cluster.eks-cluster.name

  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_pod_identity_association" "karpenter_serviceaccount_association" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  namespace = var.karpenter_namespace
  service_account = "karpenter"
  role_arn = aws_iam_role.karpenter_sa_role.arn

  depends_on = [
    aws_eks_addon.pod_identity_agent
  ]
  
}
