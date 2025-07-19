# terraform/modules/iam/variables.tf
variable "project_name" {
  description = "A unique name for the project."
  type        = string
}

variable "eks_oidc_url" {
  description = "The URL of the EKS OIDC provider."
  type        = string
}