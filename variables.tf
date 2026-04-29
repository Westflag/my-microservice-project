variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "jenkins_admin_password" {
  type      = string
  sensitive = true
  default   = "ChangeMe123!"
}

variable "gitops_repo_url" {
  type    = string
  default = "https://github.com/example/gitops-repo.git"
}

variable "gitops_repo_branch" {
  type    = string
  default = "main"
}

variable "gitops_chart_path" {
  type    = string
  default = "charts/django-app"
}


variable "grafana_admin_password" {
  type      = string
  sensitive = true
  default   = "ChangeMeGrafana123!"
}


variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "dbadmin"
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "ChangeMe123!"
}

variable "db_port" {
  type    = number
  default = 5432
}
