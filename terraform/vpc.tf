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
