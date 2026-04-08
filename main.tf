module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "andrew-brelyk-lesson-7-tfstate"
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "lesson-7-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "django-app-ecr"
  scan_on_push = true
}

module "eks" {
  source         = "./modules/eks"
  cluster_name   = "lesson-7-eks"
  subnet_ids     = module.vpc.private_subnet_ids
  vpc_id         = module.vpc.vpc_id
  node_group_name = "lesson-7-node-group"
  desired_size   = 2
  max_size       = 3
  min_size       = 1
  instance_types = ["t3.medium"]
  cluster_version = "1.29"
}
