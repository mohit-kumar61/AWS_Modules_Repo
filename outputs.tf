# ---------------------------------------------------------------------------
#                           VPC Module Outputs
# ---------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(module.vpc[0].vpc_id, null)
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = try(module.vpc[0].vpc_cidr, null)
}

output "subnet_ids" {
  description = "List of subnet IDs created in the VPC"
  value       = try(module.vpc[0].subnet_ids, [])
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = try(module.vpc[0].availability_zones, [])
}

# ---------------------------------------------------------------------------
#                           Backup Module Outputs
# ---------------------------------------------------------------------------

output "backup_vault_arn" {
  description = "ARN of the Backup Vault"
  value       = try(module.backup[0].backup_vault_arn, null)
}

output "backup_plan_arn" {
  description = "ARN of the Backup Plan"
  value       = try(module.backup[0].backup_plan_arn, null)
}

output "backup_role_arn" {
  description = "ARN of the Backup IAM Role"
  value       = try(module.backup[0].backup_role_arn, null)
}
