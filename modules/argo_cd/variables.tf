variable "cluster_name" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "gitops_repo_url" {
  type = string
}

variable "gitops_repo_branch" {
  type = string
}

variable "gitops_chart_path" {
  type = string
}

variable "namespace" {
  type    = string
  default = "argocd"
}
