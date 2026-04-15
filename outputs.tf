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
