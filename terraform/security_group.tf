resource "aws_security_group" "ec2_endpoint_sg" {
  name        = "eks-ec2-endpoint-sg"
  description = "Security group that allows eks to access ec2 endpoint"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_nodegroup" {
  referenced_security_group_id = aws_security_group.eks_nodegroup_sg.id
  security_group_id = aws_security_group.ec2_endpoint_sg.id
  description       = "Allow TLS to endpoint from nodegroup"
  
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_security_group" "eksauth_endpoint_sg" {
  name        = "eksauth-endpoint-sg"
  description = "Security group that allows eks to access eks-auth endpoint"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_eksnode_to_eksauth" {
  security_group_id = aws_security_group.eksauth_endpoint_sg.id
  referenced_security_group_id = aws_security_group.eks_nodegroup_sg.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_security_group" "eks_cluster_sg" {
  name = "eks-cluster-sg"
  description = "security group for the EKS cluster"
  vpc_id = var.vpc_id

  tags = {
    Name = "eks-cluster-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_from_nodegroup" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  referenced_security_group_id = aws_security_group.eks_nodegroup_sg.id
  ip_protocol = "tcp"
  to_port = 443
  from_port = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_traffic_from_cluster" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_security_group" "eks_nodegroup_sg" {
  name = "eks-nodegroup-sg"
  description = "security grou for the EKS nodegroup"
  vpc_id = var.vpc_id

  tags = {
    Name = "eks-cluster-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_from_cluster" {
  security_group_id = aws_security_group.eks_nodegroup_sg.id
  referenced_security_group_id = aws_security_group.eks_cluster_sg.id
  ip_protocol = "tcp"
  to_port = 443
  from_port = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_jumpbox" {
  security_group_id = aws_security_group.eks_nodegroup_sg.id
  cidr_ipv4 = var.vpc_cidr
  ip_protocol = "tcp"
  to_port = 22
  from_port = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_traffic_from_nodegroup" {
  security_group_id = aws_security_group.eks_nodegroup_sg.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_security_group" "eks_ecrapi_endpoint_sg" {
  name        = "eks-ecrapi-endpoint-sg"
  description = "Security group that allows eks to access ecr api endpoint"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ecrapi_nodegroup" {
  referenced_security_group_id = aws_security_group.eks_nodegroup_sg.id
  security_group_id = aws_security_group.eks_ecrapi_endpoint_sg.id
  description       = "Allow TLS to endpoint from nodegroup"
  
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_security_group" "eks_ecrdkr_endpoint_sg" {
  name        = "eks-ecrdkr-endpoint-sg"
  description = "Security group that allows eks to access ecr dkr endpoint"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ecrdkr_nodegroup" {
  referenced_security_group_id = aws_security_group.eks_nodegroup_sg.id
  security_group_id = aws_security_group.eks_ecrdkr_endpoint_sg.id
  description       = "Allow TLS to endpoint from nodegroup"
  
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_security_group" "eks_s3_endpoint_sg" {
  name        = "eks-s3-endpoint-sg"
  description = "Security group that allows eks to access s3 endpoint"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_s3_nodegroup" {
  referenced_security_group_id = aws_security_group.eks_nodegroup_sg.id
  security_group_id = aws_security_group.eks_s3_endpoint_sg.id
  description       = "Allow S3 to endpoint from nodegroup"
  
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}
