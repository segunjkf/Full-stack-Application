resource "aws_vpc" "full-stack-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    name = var.env_code
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_cidr)

  vpc_id = aws_vpc.full-stack-vpc.id

  cidr_block = var.private_cidr[count.index]

  availability_zone = data.aws_availability_zones.available-names.names[count.index]

  tags = {
    name = "${var.env_code}-private${count.index}"
    "kubernetes.io/cluster/eks" = "shared"
  }
}

data "aws_availability_zones" "available-names" {
  state = "available"
}

resource "aws_subnet" "public" {
  count = length(var.public_cidr)

  vpc_id     = aws_vpc.full-stack-vpc.id
  cidr_block = var.public_cidr[count.index]

  map_public_ip_on_launch = true

  availability_zone = data.aws_availability_zones.available-names.names[count.index]

  tags = {
    name = "${var.env_code}-public${count.index}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.full-stack-vpc.id

  tags = {
    name = var.env_code
  }
}

resource "aws_nat_gateway" "main" {
  count = length(var.public_cidr)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    name = "${var.env_code}-main${count.index}"
  }
}

resource "aws_eip" "nat" {
  count = length(var.private_cidr)

  vpc = true

  tags = {
    name = "${var.env_code}-nats${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_cidr)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_cidr)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.full-stack-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_cidr)

  vpc_id = aws_vpc.full-stack-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    name = "private${count.index}"
  }
}

