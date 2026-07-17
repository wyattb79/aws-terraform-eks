//provider "helm" {
//  kubernetes = {
//    host = aws_eks_cluster.eks-cluster.endpoint
//    cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority[0].data)
//    exec = {
//      api_version = "client.authentication.k8s.io/v1beta1"
//      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks-cluster.id]
//      command     = "aws"
//    }
//  }
//}
//
//resource "helm_release" "karpenter" {
//  name = "argocd"
//  repository = "oci://public.ecr.aws/karpenter"
//  chart = "karpenter"
//  version = var.karpenter_chart_version
//  namespace = var.karpenter_namespace
//  create_namespace = true
//}
