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

# ---------------------------------------------------------------------------
#                           EC2 Module Outputs
# ---------------------------------------------------------------------------

output "ec2_instance_id" {
  description = "ID of the EC2 instance."
  value       = try(module.ec2[0].instance_id, null)
}

output "ec2_instance_ids" {
  description = "IDs of the EC2 instances."
  value       = try(module.ec2[0].instance_ids, [])
}

output "ec2_key_name" {
  description = "Name of the generated EC2 key pair."
  value       = try(module.ec2[0].key_name, null)
}

output "ec2_private_key_s3_uri" {
  description = "S3 URI containing the generated private key."
  value       = try(module.ec2[0].private_key_s3_uri, null)
}
