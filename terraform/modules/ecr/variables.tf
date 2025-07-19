# terraform/modules/ecr/variables.tf
variable "project_name" {
  description = "A unique name for the project."
  type        = string
}