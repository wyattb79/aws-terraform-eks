resource "aws_security_group" "ec2_endpoint_sg" {
  name        = "eks-ec2-endpoint-sg"
  description = "Security group that allows eks to access ec2 endpoint"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_subnet_a" {
  security_group_id = aws_security_group.ec2_endpoint_sg.id
  description       = "Allow TLS to endpoint"
  
  cidr_ipv4   = aws_subnet.subnet_a.cidr_block
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_subnet_b" {
  security_group_id = aws_security_group.ec2_endpoint_sg.id
  description       = "Allow TLS to endpoint"
  
  cidr_ipv4   = aws_subnet.subnet_b.cidr_block
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

