# ---------------------------------------------------------------------------
#                           VPC Module
# ---------------------------------------------------------------------------

module "vpc" {
  count = var.enable_vpc ? 1 : 0

  source = "./modules/vpc"

  vpc_cidr     = var.vpc_cidr
  name         = var.name
  num_subnets  = var.num_subnets
  subnet_cidrs = var.subnet_cidrs
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
