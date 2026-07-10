variable "eks-keypair" {
  type = string
  description = "ec2 keypair used to login to the cluster nodes"
}

variable "k8s_version" {
  type = string
  description = "version of k8s to run on the cluster"
}

variable "partition" {
  type = string
  description = "the AWS partition that the  cluster is running in"
}

variable "vpc_id" {
  type = string
  description = "eks VPC"
}

variable "vpc_cidr" {
  type = string
  description = "VPC cidr block"
}

variable "eks_admin_group" {
  type = string
  description = "Name of IAM group for cluster admins"
}

variable "karpenter_namespace" {
  type = string
  description = "namespace where karpenter runs"
}

variable "use_karpenter" {
  type = bool
  default = false
}

variable "karpenter_chart_version" {
  type = string
}
