# Terraform version requirement (optional but recommended)
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region
}

# AWS EC2 Instance Resource
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "TerraformExampleInstance"
  }
}