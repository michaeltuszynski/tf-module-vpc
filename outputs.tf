output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this_vpc.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = length(aws_subnet.public_subnet) > 0 ? aws_subnet.public_subnet[0].id : null
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = length(aws_subnet.private_subnet) > 0 ? aws_subnet.private_subnet[0].id : null
}

output "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  value       = length(aws_nat_gateway.this_nat_gateway) > 0 ? aws_nat_gateway.this_nat_gateway[0].id : null
}
