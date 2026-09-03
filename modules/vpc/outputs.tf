output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "subnet_ids" {
  description = "Subnet IDs in subnet definition order"
  value       = [for index in range(length(local.subnet_definitions)) : aws_subnet.main[tostring(index)].id]
}

output "availability_zones" {
  description = "Availability zones in subnet definition order"
  value       = [for index in range(length(local.subnet_definitions)) : aws_subnet.main[tostring(index)].availability_zone]
}

output "public_route_table_id" {
  description = "Public route table ID, if created"
  value       = try(aws_route_table.public[0].id, null)
}

output "private_route_table_id" {
  description = "Private route table ID, if created"
  value       = try(aws_route_table.private[0].id, null)
}
