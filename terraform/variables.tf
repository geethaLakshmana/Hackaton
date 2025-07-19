# terraform/variables.tf
variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-west-1"
}

variable "project_name" {
  description = "A unique name for the project, used in resource naming."
  type        = string
  default     = "nodejs-eks-app"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.32"
}

variable "instance_types" {
  description = "Instance types for EKS worker nodes."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 1
}