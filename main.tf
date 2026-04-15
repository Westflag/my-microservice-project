module "s3_backend" { source = "./modules/s3-backend" bucket_name = "andrew-brelyk-project-tfstate" table_name = "terraform-locks" }
module "vpc" { source = "./modules/vpc" vpc_cidr_block = "10.0.0.0/16" public_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"] private_subnets = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"] availability_zones = ["us-west-2a","us-west-2b","us-west-2c"] vpc_name = "project-vpc" }
module "ecr" { source = "./modules/ecr" ecr_name = "django-app-ecr" scan_on_push = true }
module "eks" { source = "./modules/eks" cluster_name = "project-eks" subnet_ids = module.vpc.private_subnet_ids vpc_id = module.vpc.vpc_id node_group_name = "project-node-group" desired_size = 2 max_size = 3 min_size = 1 instance_types = ["t3.medium"] cluster_version = "1.29" }
module "jenkins" { source = "./modules/jenkins" cluster_name = module.eks.cluster_name cluster_endpoint = module.eks.cluster_endpoint cluster_ca_certificate = module.eks.cluster_ca_certificate jenkins_admin_password = var.jenkins_admin_password region = var.aws_region ecr_repository_url = module.ecr.repository_url gitops_repo_url = var.gitops_repo_url gitops_repo_branch = var.gitops_repo_branch gitops_chart_path = var.gitops_chart_path depends_on = [module.eks] }
module "argo_cd" { source = "./modules/argo_cd" cluster_name = module.eks.cluster_name cluster_endpoint = module.eks.cluster_endpoint cluster_ca_certificate = module.eks.cluster_ca_certificate gitops_repo_url = var.gitops_repo_url gitops_repo_branch = var.gitops_repo_branch gitops_chart_path = var.gitops_chart_path depends_on = [module.eks] }


module "rds" {
  source                 = "./modules/rds"
  name                   = "app-postgres"
  use_aurora             = false
  engine                 = "postgres"
  engine_version         = "16.3"
  parameter_group_family = "postgres16"
  instance_class         = "db.t3.medium"
  allocated_storage      = 20
  storage_type           = "gp3"
  multi_az               = false

  database_name          = "appdb"
  username               = "dbadmin"
  password               = "ChangeMe123!"
  port                   = 5432

  subnet_ids             = module.vpc.private_subnet_ids
  vpc_id                 = module.vpc.vpc_id
  allowed_cidr_blocks    = ["10.0.0.0/16"]

  max_connections        = "100"
  log_statement          = "all"
  work_mem               = "4096"
}
