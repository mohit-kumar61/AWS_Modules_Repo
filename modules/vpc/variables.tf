variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "name" {
  description = "The name prefix for VPC resources."
  type        = string
}

variable "num_subnets" {
  description = "Number of subnets to create."
  type        = number
}

variable "subnet_cidrs" {
  description = "Custom CIDR blocks for subnets."
  type        = list(string)
}
