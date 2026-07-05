resource "aws_vpc_endpoint" "eks-ec2-endpoint" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.us-east-1.ec2"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]

  security_group_ids = [
    aws_security_group.ec2_endpoint_sg.id
  ]
}

resource "aws_vpc_endpoint" "eks-auth-endpoint" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.us-east-1.eks-auth"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]

  security_group_ids = [
    aws_security_group.eksauth_endpoint_sg.id
  ]
}

resource "aws_vpc_endpoint" "eks-ecrapi-endpoint" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]

  security_group_ids = [
    aws_security_group.eks_ecrapi_endpoint_sg.id
  ]
}

resource "aws_vpc_endpoint" "eks-ecrdkr-endpoint" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]

  security_group_ids = [
    aws_security_group.eks_ecrdkr_endpoint_sg.id
  ]
}

resource "aws_vpc_endpoint" "eks-s3-endpoint" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [data.aws_vpc.subnet_a_vpc.main_route_table_id]
}
