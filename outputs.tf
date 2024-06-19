output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this_vpc.id
}

output "public_subnet_ids" {
  description = "The ID of the public subnet"
  value       = var.subnet_type == "public" || var.subnet_type == "both" ? aws_subnet.public_subnet[*].id : []
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = var.subnet_type == "private" || var.subnet_type == "both" ? aws_subnet.private_subnet[*].id : []
}

output "nat_gateway_id" {
  description = "The IDs of the private subnets"
  value       = var.subnet_type == "private" || var.subnet_type == "both" ? aws_subnet.this_nat_gateway.id : []
}
