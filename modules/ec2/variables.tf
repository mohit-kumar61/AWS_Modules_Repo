variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "server_count" {
  description = "Number of EC2 instances to launch."
  type        = number

  validation {
    condition     = var.server_count >= 1 && floor(var.server_count) == var.server_count
    error_message = "server_count must be a whole number greater than or equal to one."
  }
}

variable "key_name" {
  description = "Name of the generated EC2 key pair."
  type        = string
}

variable "volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number

  validation {
    condition     = var.volume_size > 0
    error_message = "volume_size must be greater than zero."
  }
}

variable "volume_type" {
  description = "Root EBS volume type."
  type        = string

  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2", "sc1", "st1", "standard"], var.volume_type)
    error_message = "volume_type must be a supported EBS volume type."
  }
}

variable "os_type" {
  description = "Operating system for the EC2 instance: linux, ubuntu, or windows."
  type        = string

  validation {
    condition     = contains(["linux", "amazon_linux", "ubuntu", "windows"], var.os_type)
    error_message = "os_type must be linux, amazon_linux, ubuntu, or windows."
  }
}
