resource "aws_vpc" "this_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Type = "this_vpc"
  }
}

# Conditionally create public subnets
resource "aws_subnet" "public_subnet" {
  count                   = var.subnet_type == "public" || var.subnet_type == "both" ? length(var.public_subnet_cidrs) : 0
  vpc_id                  = aws_vpc.this_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Type = "public_subnet"
  }
}

# Conditionally create private subnets
resource "aws_subnet" "private_subnet" {
  count      = var.subnet_type == "private" || var.subnet_type == "both" ? length(var.private_subnet_cidrs) : 0
  vpc_id     = aws_vpc.this_vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = {
    Type = "private_subnet"
  }
}

resource "aws_internet_gateway" "this_vpc_igw" {
  count  = var.subnet_type == "public" || var.subnet_type == "both" ? 1 : 0
  vpc_id = aws_vpc.this_vpc.id

  tags = {
    Type = "this_igw"
  }
}

resource "aws_nat_gateway" "this_nat_gateway" {
  count         = var.subnet_type == "private" || var.subnet_type == "both" ? length(var.private_subnet_cidrs) : 0
  allocation_id = aws_eip.this_eip[count.index].id
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index % length(var.public_subnet_cidrs))

  tags = {
    Type = "this_nat_gateway"
  }
}

resource "aws_eip" "this_eip" {
  count  = var.subnet_type == "private" || var.subnet_type == "both" ? length(var.private_subnet_cidrs) : 0
  domain = "vpc"

  tags = {
    Type = "this_eip"
  }
}

resource "aws_route_table" "public_route_table" {
  count  = var.subnet_type == "public" || var.subnet_type == "both" ? 1 : 0
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this_vpc_igw[0].id
  }

  tags = {
    Type = "public_route_table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = var.subnet_type == "public" || var.subnet_type == "both" ? length(var.public_subnet_cidrs) : 0
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table[0].id
}

resource "aws_route_table" "private_route_table" {
  count  = var.subnet_type == "private" || var.subnet_type == "both" ? length(var.private_subnet_cidrs) : 0
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.this_nat_gateway.*.id, count.index % length(var.private_subnet_cidrs))
  }

  tags = {
    Type = "private_route_table"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = var.subnet_type == "private" || var.subnet_type == "both" ? length(var.private_subnet_cidrs) : 0
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}
