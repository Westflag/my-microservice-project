resource "kubernetes_namespace" "jenkins" { metadata { name = "jenkins" } }
resource "helm_release" "jenkins" { name = "jenkins" repository = "https://charts.jenkins.io" chart = "jenkins" namespace = kubernetes_namespace.jenkins.metadata[0].name }
