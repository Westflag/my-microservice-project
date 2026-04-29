variable "cluster_name" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "namespace" {
  type    = string
  default = "monitoring"
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
  default   = "ChangeMeGrafana123!"
}

variable "chart_version" {
  type    = string
  default = "58.7.1"
}
