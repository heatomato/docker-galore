# AWS Region Variable
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

# Amazon Machine Image (AMI) ID Variable
variable "ami_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
  default     = "ami-02a53b0d62d37a757"  # Example AMI ID; replace with a valid one for your region
}

# Instance Type Variable
variable "instance_type" {
  description = "The type of EC2 instance."
  type        = string
  default     = "t2.micro"
}