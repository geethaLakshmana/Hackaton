# terraform/modules/iam/outputs.tf
output "alb_controller_iam_role_arn" {
  description = "IAM Role ARN for AWS Load Balancer Controller."
  value       = aws_iam_role.alb_controller_role.arn
}

output "eks_oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider."
  value       = aws_iam_openid_connect_provider.eks_oidc_provider.arn
}