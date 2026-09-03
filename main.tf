# ---------------------------------------------------------------------------
#                           VPC Module
# ---------------------------------------------------------------------------

module "internal_vpc" {
  count  = var.enable_internal_vpc ? 1 : 0
  source = "./modules/vpc"

  name                    = "Internal"
  vpc_cidr                = var.internal_vpc_cidr
  public_subnet_count     = 0
  private_subnet_count    = var.internal_private_subnet_count
  subnet_cidrs           = var.internal_subnet_cidrs
  create_internet_gateway = false
  create_nat_gateway      = false
}

module "dmz_vpc" {
  count  = var.enable_dmz_vpc ? 1 : 0
  source = "./modules/vpc"

  name                    = "DMZ"
  vpc_cidr                = var.dmz_vpc_cidr
  public_subnet_count    = var.dmz_public_subnet_count
  private_subnet_count   = 0
  subnet_cidrs           = var.dmz_subnet_cidrs
  create_internet_gateway = true
}

module "standalone_vpc" {
  count  = var.enable_standalone_vpc ? 1 : 0
  source = "./modules/vpc"

  name                    = "VPC"
  subnet_name_style       = "type"
  vpc_cidr                = var.standalone_vpc_cidr
  public_subnet_count    = var.standalone_public_subnet_count
  private_subnet_count   = var.standalone_private_subnet_count
  subnet_cidrs           = var.standalone_subnet_cidrs
  create_internet_gateway = true
  create_nat_gateway      = true
}

resource "aws_vpc_peering_connection" "internal_dmz" {
  count       = var.enable_internal_vpc && var.enable_dmz_vpc && var.enable_vpc_peering ? 1 : 0
  vpc_id      = module.internal_vpc[0].vpc_id
  peer_vpc_id = module.dmz_vpc[0].vpc_id
  auto_accept = var.auto_accept_vpc_peering

  tags = {
    Name = "Internal-to-DMZ"
  }
}

resource "aws_route" "internal_to_dmz" {
  count                  = var.enable_internal_vpc && var.enable_dmz_vpc && var.enable_vpc_peering ? 1 : 0
  route_table_id         = coalesce(module.internal_vpc[0].private_route_table_id, module.internal_vpc[0].public_route_table_id)
  destination_cidr_block = var.dmz_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.internal_dmz[0].id
}

resource "aws_route" "dmz_to_internal" {
  count                  = var.enable_internal_vpc && var.enable_dmz_vpc && var.enable_vpc_peering ? 1 : 0
  route_table_id         = coalesce(module.dmz_vpc[0].public_route_table_id, module.dmz_vpc[0].private_route_table_id)
  destination_cidr_block = var.internal_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.internal_dmz[0].id
}

# ---------------------------------------------------------------------------
#                           Backup Module
# ---------------------------------------------------------------------------

module "backup" {
  count = var.enable_backup ? 1 : 0

  source = "./modules/backup"

  backup_schedule   = var.backup_schedule
  retention_days    = var.retention_days
  backup_tag_key    = var.backup_tag_key
  backup_tag_value  = var.backup_tag_value
}
