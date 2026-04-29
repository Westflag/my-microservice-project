resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false
  timeout          = 1200

  values = [
    file("${path.module}/values.yaml")
  ]
}

resource "helm_release" "argo_apps" {
  name      = "argo-apps"
  chart     = "${path.module}/charts"
  namespace = kubernetes_namespace.argocd.metadata[0].name

  values = [
    yamlencode({
      repositories = [
        {
          url = var.gitops_repo_url
        }
      ]
      applications = [
        {
          name           = "django-app"
          repoURL        = var.gitops_repo_url
          targetRevision = var.gitops_repo_branch
          path           = var.gitops_chart_path
          namespace      = "django-app"
        }
      ]
    })
  ]

  depends_on = [helm_release.argo_cd]
}
