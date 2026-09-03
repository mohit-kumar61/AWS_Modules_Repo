variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "enable_internal_vpc" {
  description = "Enable the Internal VPC."
  type        = bool
  default     = false
}

variable "internal_vpc_cidr" {
  description = "CIDR block for the Internal VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "internal_private_subnet_count" {
  description = "Number of private subnets in the Internal VPC."
  type        = number
  default     = 2

  validation {
    condition     = var.internal_private_subnet_count >= 0
    error_message = "internal_private_subnet_count must be zero or greater."
  }
}

variable "internal_subnet_cidrs" {
  description = "Optional Internal VPC subnet CIDRs in public-then-private order."
  type        = list(string)
  default     = []
}

##########################################################################################

variable "enable_dmz_vpc" {
  description = "Enable the DMZ VPC."
  type        = bool
  default     = true
}

variable "dmz_vpc_cidr" {
  description = "CIDR block for the DMZ VPC."
  type        = string
  default     = "10.2.0.0/16"
}

variable "dmz_public_subnet_count" {
  description = "Number of public subnets in the DMZ VPC."
  type        = number
  default     = 2

  validation {
    condition     = var.dmz_public_subnet_count >= 0
    error_message = "dmz_public_subnet_count must be zero or greater."
  }
}
variable "dmz_subnet_cidrs" {
  description = "Optional DMZ VPC subnet CIDRs."
  type        = list(string)
  default     = []
}

#######################################################################################

variable "enable_standalone_vpc" {
  description = "Enable the standalone VPC."
  type        = bool
  default     = false
}

variable "standalone_vpc_cidr" {
  description = "CIDR block for the standalone VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "standalone_subnet_cidrs" {
  description = "Optional standalone VPC subnet CIDRs in public-then-private order."
  type        = list(string)
  default     = []
}

variable "standalone_public_subnet_count" {
  description = "Number of public subnets in the standalone VPC."
  type        = number
  default     = 1

  validation {
    condition     = var.standalone_public_subnet_count >= 0
    error_message = "standalone_public_subnet_count must be zero or greater."
  }
}

variable "standalone_private_subnet_count" {
  description = "Number of private subnets in the standalone VPC."
  type        = number
  default     = 2

  validation {
    condition     = var.standalone_private_subnet_count >= 0
    error_message = "standalone_private_subnet_count must be zero or greater."
  }
}

##########################################################################################

variable "enable_vpc_peering" {
  description = "Create peering between the enabled Internal and DMZ VPCs."
  type        = bool
  default     = false
}

variable "auto_accept_vpc_peering" {
  description = "Automatically accept the VPC peering connection."
  type        = bool
  default     = false
}

##########################################################################################
variable "enable_backup" {
  description = "Enable or disable Backup module deployment"
  type        = bool
  default     = false
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

##########################################################################################

variable "enable_ec2" {
  description = "Enable the EC2 module."
  type        = bool
  default     = false
}

variable "ec2_instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = length(trimspace(var.ec2_instance_type)) > 0
    error_message = "ec2_instance_type must not be empty."
  }
}

variable "ec2_server_count" {
  description = "Number of EC2 instances to launch."
  type        = number
  default     = 1

  validation {
    condition     = var.ec2_server_count >= 1 && floor(var.ec2_server_count) == var.ec2_server_count
    error_message = "ec2_server_count must be a whole number greater than or equal to one."
  }
}

variable "ec2_key_name" {
  description = "Name of the generated EC2 key pair."
  type        = string
  default     = "ec2-key"

  validation {
    condition     = length(trimspace(var.ec2_key_name)) > 0
    error_message = "ec2_key_name must not be empty."
  }
}

variable "ec2_volume_size" {
  description = "EC2 root EBS volume size in GiB."
  type        = number
  default     = 100

  validation {
    condition     = var.ec2_volume_size > 0
    error_message = "ec2_volume_size must be greater than zero."
  }
}

variable "ec2_volume_type" {
  description = "EC2 root EBS volume type."
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2", "sc1", "st1", "standard"], var.ec2_volume_type)
    error_message = "ec2_volume_type must be a supported EBS volume type."
  }
}

variable "ec2_os_type" {
  description = "EC2 operating system: linux, ubuntu, or windows."
  type        = string
  default     = "amazon_linux"

  validation {
    condition     = contains(["linux", "amazon_linux", "ubuntu", "windows"], var.ec2_os_type)
    error_message = "ec2_os_type must be linux, amazon_linux, ubuntu, or windows."
  }
}

