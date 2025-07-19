# terraform/modules/eks/outputs.tf
output "kubeconfig" {
  description = "Kubeconfig for the EKS cluster."
  value       = module.eks_cluster.kubeconfig
  sensitive   = true
}

output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks_cluster.cluster_name
}

output "oidc_provider_url" {
  description = "URL of the EKS OIDC provider."
  value       = module.eks_cluster.oidc_provider_extract_from_arn # This is the full URL
}