# terraform/modules/vpc/variables.tf
variable "project_name" {
  description = "A unique name for the project."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
}

variable "aws_region" {
  description = "The AWS region for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones for subnets."
  type        = list(string)
}