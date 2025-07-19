# terraform/modules/ecr/main.tf
resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.project_name}-repository"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.project_name}-ecr-repo"
  }
}