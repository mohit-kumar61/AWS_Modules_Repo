# Data source to fetch available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  subnet_count = var.public_subnet_count + var.private_subnet_count

  subnet_definitions = [
    for index in range(local.subnet_count) : {
      cidr_block        = length(var.subnet_cidrs) > 0 ? var.subnet_cidrs[index] : cidrsubnet(var.vpc_cidr, 2, index)
      type              = index < var.public_subnet_count ? "public" : "private"
      type_index        = index < var.public_subnet_count ? index : index - var.public_subnet_count
      availability_zone = null
    }
  ]

  # Dynamically select AZs based on number of subnets (up to available AZs count)
  azs = slice(data.aws_availability_zones.available.names, 0, min(local.subnet_count, length(data.aws_availability_zones.available.names)))
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  lifecycle {
    precondition {
      condition     = !var.create_nat_gateway || var.public_subnet_count > 0
      error_message = "A NAT Gateway requires at least one public subnet."
    }
  }

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "main" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_subnet" "main" {
  for_each          = { for index, subnet in local.subnet_definitions : index => subnet }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = coalesce(each.value.availability_zone, local.azs[each.key % length(local.azs)])
  map_public_ip_on_launch = each.value.type == "public"

  tags = {
    Name = var.subnet_name_style == "type" ? "${title(each.value.type)}Subnet-${substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", each.value.type_index, 1)}" : "${var.name}-${substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", each.key, 1)}"
    Type = each.value.type
  }
}

resource "aws_route_table" "public" {
  count  = var.create_internet_gateway && var.public_subnet_count > 0 ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }

  tags = {
    Name = "${var.name}-public"
    Type = "public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = {
    for index, subnet in local.subnet_definitions : index => subnet
    if subnet.type == "public" && var.create_internet_gateway
  }

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_eip" "nat" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.main["0"].id

  tags = {
    Name = "${var.name}-nat"
  }
}

resource "aws_route_table" "private" {
  count  = var.private_subnet_count > 0 ? 1 : 0
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.create_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[0].id
    }
  }

  tags = {
    Name = "${var.name}-private"
    Type = "private"
  }
}

resource "aws_route_table_association" "private" {
  for_each = {
    for index, subnet in local.subnet_definitions : index => subnet
    if subnet.type == "private"
  }

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.private[0].id
}
