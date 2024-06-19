resource "aws_vpc" "this_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Type = "this_vpc"
  }
}

# Conditionally create public subnet
resource "aws_subnet" "public_subnet" {
  count                   = var.subnet_type == "public" || var.subnet_type == "both" ? 1 : 0
  vpc_id                  = aws_vpc.this_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Type = "public_subnet"
  }
}

# Conditionally create private subnet
resource "aws_subnet" "private_subnet" {
  count      = var.subnet_type == "private" || var.subnet_type == "both" ? 1 : 0
  vpc_id     = aws_vpc.this_vpc.id
  cidr_block = var.private_subnet_cidr

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
  count         = var.subnet_type == "private" || var.subnet_type == "both" ? 1 : 0
  allocation_id = aws_eip.this_eip[count.index].id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = {
    Type = "this_nat_gateway"
  }
}

resource "aws_eip" "this_eip" {
  count  = var.subnet_type == "private" || var.subnet_type == "both" ? 1 : 0
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
    gateway_id = aws_internet_gateway.this_vpc_igw[count.index].id
  }

  tags = {
    Type = "public_route_table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = var.subnet_type == "public" || var.subnet_type == "both" ? 1 : 0
  subnet_id      = element(aws_subnet.public_subnet.*.id, 0)
  route_table_id = element(aws_route_table.public_route_table.*.id, 0)
}

resource "aws_route_table" "private_route_table" {
  count  = var.subnet_type == "private" || var.subnet_type == "both" ? 1 : 0
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.this_nat_gateway.*.id, 0)
  }

  tags = {
    Type = "private_route_table"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = var.subnet_type == "private" || var.subnet_type == "both" ? 1 : 0
  subnet_id      = element(aws_subnet.private_subnet.*.id, 0)
  route_table_id = element(aws_route_table.private_route_table.*.id, 0)
}
