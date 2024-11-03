output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC."
}

output "public_subnet_ids" {
  value       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  description = "The IDs of the public subnets."
}

output "private_subnet_ids" {
  value       = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  description = "The IDs of the private subnets."
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.nat.id
  description = "The ID of the NAT gateway."
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.igw.id
  description = "The ID of the Internet gateway."
}
