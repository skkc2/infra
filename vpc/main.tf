resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = element(var.region_availability_zones, count.index)

  tags = {
    Name = "public-${element(var.region_availability_zones, count.index)}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = element(var.region_availability_zones, count.index)

  tags = {
    Name = "private-${element(var.region_availability_zones, count.index)}"
  }
}

resource "aws_subnet" "db_private" {
  count             = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_private_subnet_cidr_blocks[count.index]
  availability_zone = element(var.region_availability_zones, count.index)

  tags = {
    Name = "db_private-${element(var.region_availability_zones, count.index)}"
  }
}

# resource "aws_security_group" "main" {
#   vpc_id = aws_vpc.main.id

#   // Define ingress and egress rules for the main security group
# }

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id      = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "Private Route Table"
  }
  depends_on = [ aws_nat_gateway.nat ]
}

resource "aws_route_table" "db_private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id      = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "DB Private Route Table"
  }
  depends_on = [ aws_nat_gateway.nat ]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}

resource "aws_eip" "nat" {
  vpc = true
}


resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db_private" {
  count          = length(aws_subnet.db_private)
  subnet_id      = aws_subnet.db_private[count.index].id
  route_table_id = aws_route_table.db_private.id
}

