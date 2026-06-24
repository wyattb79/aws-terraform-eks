resource "aws_subnet" "subnet_a" {
  vpc_id = var.vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone   = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "subnet_b" {
  vpc_id = var.vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone   = data.aws_availability_zones.available.names[1]
}
