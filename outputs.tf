# ---------------------------------------------------------------------------
#                           VPC Module Outputs
# ---------------------------------------------------------------------------

output "vpc_id" {
  description = "The standalone VPC ID, or null in separate mode"
  value       = try(module.standalone_vpc[0].vpc_id, null)
}

output "vpc_cidr" {
  description = "The standalone VPC CIDR, or null in separate mode"
  value       = try(module.standalone_vpc[0].vpc_cidr, null)
}

output "subnet_ids" {
  description = "Standalone VPC subnet IDs, or an empty list in separate mode"
  value       = try(module.standalone_vpc[0].subnet_ids, [])
}

output "availability_zones" {
  description = "Standalone VPC availability zones, or an empty list in separate mode"
  value       = try(module.standalone_vpc[0].availability_zones, [])
}

output "internal_vpc_id" {
  description = "The Internal VPC ID in separate mode"
  value       = try(module.internal_vpc[0].vpc_id, null)
}

output "dmz_vpc_id" {
  description = "The DMZ VPC ID in separate mode"
  value       = try(module.dmz_vpc[0].vpc_id, null)
}

output "vpc_peering_id" {
  description = "The Internal-to-DMZ peering connection ID"
  value       = try(aws_vpc_peering_connection.internal_dmz[0].id, null)
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
