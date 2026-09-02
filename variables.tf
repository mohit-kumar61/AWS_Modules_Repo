variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "backup_tag_key" {
  description = "Tag key to identify resources for backup"
  type        = string
  default     = "Backup"
}

variable "backup_tag_value" {
  description = "Tag value to identify resources for backup"
  type        = string
  default     = "true"
}

variable "backup_schedule" {
  description = "Cron expression for backup schedule (e.g., 'cron(0 5 * * ? *)')"
  type        = string
  default     = "cron(0 5 * * ? *)"  # Daily at 5 AM UTC
}

variable "retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 14
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "name" {
  description = "The name of the VPC."
  type        = string
  default     = "Internal-VPC"
}

variable "num_subnets" {
  description = "Number of subnets to create. If more than available AZs, will cycle through AZs (e.g., 5 subnets across 3 AZs = AZ1, AZ2, AZ3, AZ1, AZ2)"
  type        = number
  default     = 3
  
  validation {
    condition     = var.num_subnets > 0
    error_message = "num_subnets must be greater than 0."
  }
}

variable "subnet_cidrs" {
  description = "Custom CIDR blocks for subnets. If empty, will be calculated from VPC CIDR. Should match num_subnets count"
  type        = list(string)
  default     = []
}

variable "enable_vpc" {
  description = "Enable or disable VPC module deployment"
  type        = bool
  default     = true
}

variable "enable_backup" {
  description = "Enable or disable Backup module deployment"
  type        = bool
  default     = true
}
