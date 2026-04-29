output "namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
}

output "server_service_name" {
  value = "argocd-server"
}
