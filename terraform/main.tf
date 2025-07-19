# terraform/main.tf

# Get available AZs for VPC module
data "aws_availability_zones" "available" {
  state = "available"
}

# 1. VPC Module Call
module "vpc" {
  source = "./modules/vpc" # Points to the local VPC module folder

  project_name       = var.project_name
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  aws_region         = var.aws_region
  availability_zones = data.aws_availability_zones.available.names
}

# 2. EKS Cluster Module Call
module "eks" {
  source = "./modules/eks" # Points to the local EKS module folder

  project_name      = var.project_name
  aws_region        = var.aws_region
  cluster_version   = var.cluster_version
  instance_types    = var.instance_types
  desired_size      = var.desired_size
  max_size          = var.max_size
  min_size          = var.min_size
  vpc_id            = module.vpc.vpc_id # Output from VPC module
  private_subnet_ids = module.vpc.private_subnet_ids # Output from VPC module
}

# 3. ECR Repository Module Call
module "ecr" {
  source = "./modules/ecr" # Points to the local ECR module folder

  project_name = var.project_name
}

# 4. IAM Module Call (for OIDC Provider and ALB Controller Role)
module "iam" {
  source = "./modules/iam" # Points to the local IAM module folder

  project_name    = var.project_name
  eks_oidc_url    = module.eks.oidc_provider_url # Output from EKS module
  # For the ALB Controller policy, it needs the full URL not just the extract from arn
}