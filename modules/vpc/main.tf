# Data source to fetch available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Dynamically select AZs based on number of subnets (up to available AZs count)
  azs = slice(data.aws_availability_zones.available.names, 0, min(var.num_subnets, length(data.aws_availability_zones.available.names)))
  
  # Calculate subnet CIDR blocks if not provided
  # Split VPC CIDR into /21 subnets (8 subnets available)
  # This gives us flexibility to create multiple subnets
  subnet_cidrs = length(var.subnet_cidrs) > 0 ? var.subnet_cidrs : [
    for i in range(var.num_subnets) : cidrsubnet(var.vpc_cidr, 2, i)
  ]
  
  # Map subnet index to AZ (cycles through available AZs)
  # If num_subnets=5 and azs=3, distribution is: AZ1, AZ2, AZ3, AZ1, AZ2
  subnet_to_az = {
    for i in range(var.num_subnets) : i => local.azs[i % length(local.azs)]
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

# Subnets - Dynamic creation based on num_subnets variable
# Cycles through available AZs if num_subnets > num_azs
resource "aws_subnet" "main" {
  count             = var.num_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.subnet_cidrs[count.index]
  availability_zone = local.subnet_to_az[count.index]

  tags = {
    Name = "${var.name}-subnet-${count.index + 1}"
    Type = "Subnet"
  }
}