output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this_vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "The ID of the public subnet"
  value       = length(aws_subnet.public_subnet) > 0 ? aws_subnet.public_subnet[*].id : []
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = length(aws_subnet.private_subnet) > 0 ? aws_subnet.private_subnet[*].id : []
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables"
  value       = length(aws_route_table.private_route_table) > 0 ? aws_route_table.private_route_table[*].id : []
}
