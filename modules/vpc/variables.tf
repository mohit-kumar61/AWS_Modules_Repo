variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "name" {
  description = "The name prefix for VPC resources."
  type        = string
}

variable "subnet_name_style" {
  description = "Subnet naming style: vpc produces Internal-A; type produces PublicSubnet-A and PrivateSubnet-A."
  type        = string
  default     = "vpc"

  validation {
    condition     = contains(["vpc", "type"], var.subnet_name_style)
    error_message = "subnet_name_style must be vpc or type."
  }
}

variable "public_subnet_count" {
  description = "Number of public subnets to create."
  type        = number

  validation {
    condition     = var.public_subnet_count >= 0
    error_message = "public_subnet_count must be zero or greater."
  }
}

variable "private_subnet_count" {
  description = "Number of private subnets to create."
  type        = number

  validation {
    condition     = var.private_subnet_count >= 0
    error_message = "private_subnet_count must be zero or greater."
  }
}

variable "subnet_cidrs" {
  description = "Optional custom CIDR blocks. If empty, CIDRs are calculated from vpc_cidr."
  type        = list(string)
  default     = []
}

variable "create_internet_gateway" {
  description = "Create an Internet Gateway and public route table."
  type        = bool
  default     = true
}

variable "create_nat_gateway" {
  description = "Create a NAT Gateway in the first public subnet and route private subnets through it."
  type        = bool
  default     = false
}
