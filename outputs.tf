output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "jenkins_namespace" {
  value = module.jenkins.namespace
}

output "argocd_namespace" {
  value = module.argo_cd.namespace
}


output "rds_endpoint" {
  description = "RDS or Aurora endpoint"
  value       = module.rds.db_endpoint
}

output "rds_security_group_id" {
  description = "Database security group ID"
  value       = module.rds.security_group_id
}

output "rds_parameter_group_name" {
  description = "Database parameter group name"
  value       = module.rds.parameter_group_name
}


output "monitoring_namespace" {
  value = module.monitoring.namespace
}

output "grafana_service_name" {
  value = module.monitoring.grafana_service_name
}

output "prometheus_service_name" {
  value = module.monitoring.prometheus_service_name
}
