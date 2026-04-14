resource "kubernetes_namespace" "argocd" { metadata { name = "argocd" } }
resource "helm_release" "argo_cd" { name = "argo-cd" repository = "https://argoproj.github.io/argo-helm" chart = "argo-cd" namespace = kubernetes_namespace.argocd.metadata[0].name }
resource "helm_release" "argo_apps" { name = "argo-apps" chart = "${path.module}/charts/argo-apps" namespace = kubernetes_namespace.argocd.metadata[0].name depends_on = [helm_release.argo_cd] }
