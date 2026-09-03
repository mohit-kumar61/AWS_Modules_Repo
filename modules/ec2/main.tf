data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

locals {
  ami_owner = var.os_type == "ubuntu" ? "099720109477" : "amazon"
  ami_name  = var.os_type == "ubuntu" ? "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" : var.os_type == "windows" ? "Windows_Server-2022-English-Full-Base-*" : "al2023-ami-2023*-x86_64"
}

data "aws_ami" "selected" {
  most_recent = true
  owners      = [local.ami_owner]

  filter {
    name   = "name"
    values = [local.ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  lower   = true
  numeric = true
  special = false
  upper   = false
}

resource "tls_private_key" "ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2.public_key_openssh
}

resource "aws_s3_bucket" "keypair" {
  bucket        = "keypair-bucket-${random_string.bucket_suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "keypair" {
  bucket = aws_s3_bucket.keypair.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "keypair" {
  bucket = aws_s3_bucket.keypair.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "private_key" {
  bucket       = aws_s3_bucket.keypair.id
  key          = "${var.key_name}.pem"
  content      = tls_private_key.ec2.private_key_pem
  content_type = "application/x-pem-file"

  depends_on = [aws_s3_bucket_server_side_encryption_configuration.keypair]
}

resource "aws_instance" "ec2" {
  count                       = var.server_count
  ami                         = data.aws_ami.selected.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ec2.key_name
  subnet_id                   = tolist(data.aws_subnets.default_vpc.ids)[0]
  vpc_security_group_ids      = [data.aws_security_group.default.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }

  tags = {
    Name = "${var.key_name}-${count.index + 1}"
  }
}
