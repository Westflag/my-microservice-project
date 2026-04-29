output "namespace" {
  value = kubernetes_namespace.monitoring.metadata[0].name
}

output "grafana_service_name" {
  value = "grafana"
}

output "prometheus_service_name" {
  value = "kube-prometheus-stack-prometheus"
}
