output "vpc-id" {
  value = aws_vpc.full-stack-vpc.id
}

output "subnet_id_public" {
  value = aws_subnet.public[*].id
}

output "subnet_id_private" {
  value = aws_subnet.private[*].id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

