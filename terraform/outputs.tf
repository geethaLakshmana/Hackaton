# terraform/outputs.tf

output "kubeconfig" {
  description = "Kubeconfig for the EKS cluster."
  value       = module.eks.kubeconfig
  sensitive   = true
}

output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository."
  value       = module.ecr.repository_url
}

output "alb_controller_iam_role_arn" {
  description = "IAM Role ARN for AWS Load Balancer Controller."
  value       = module.iam.alb_controller_iam_role_arn
}

output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private Subnet IDs."
  value       = module.vpc.private_subnet_ids
}

output "public_subnets" {
  description = "Public Subnet IDs."
  value       = module.vpc.public_subnet_ids
}