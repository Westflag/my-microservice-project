output "namespace" {
  value = kubernetes_namespace.jenkins.metadata[0].name
}

output "release_name" {
  value = helm_release.jenkins.name
}
