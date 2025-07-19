# terraform/modules/eks/outputs.tf
output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks_cluster.cluster_name
}

output "oidc_provider_url" {
  description = "URL of the EKS OIDC provider."
  value       = module.eks_cluster.cluster_oidc_issuer_url
}