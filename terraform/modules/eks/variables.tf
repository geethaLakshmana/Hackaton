# terraform/modules/eks/variables.tf
variable "project_name" {
  description = "A unique name for the project."
  type        = string
}

variable "aws_region" {
  description = "The AWS region for the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
}

variable "instance_types" {
  description = "Instance types for EKS worker nodes."
  type        = list(string)
}

variable "desired_size" {
  description = "Desired number of worker nodes."
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes."
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes."
  type        = number
}

variable "vpc_id" {
  description = "The ID of the VPC for the EKS cluster."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS worker nodes."
  type        = list(string)
}