resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  namespace        = kubernetes_namespace.jenkins.metadata[0].name
  create_namespace = false
  timeout          = 1200

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "controller.admin.password"
    value = var.jenkins_admin_password
  }

  set {
    name  = "controller.env[0].name"
    value = "AWS_REGION"
  }

  set {
    name  = "controller.env[0].value"
    value = var.region
  }

  set {
    name  = "controller.env[1].name"
    value = "ECR_REPOSITORY_URL"
  }

  set {
    name  = "controller.env[1].value"
    value = var.ecr_repository_url
  }

  set {
    name  = "controller.env[2].name"
    value = "GITOPS_REPO_URL"
  }

  set {
    name  = "controller.env[2].value"
    value = var.gitops_repo_url
  }

  set {
    name  = "controller.env[3].name"
    value = "GITOPS_REPO_BRANCH"
  }

  set {
    name  = "controller.env[3].value"
    value = var.gitops_repo_branch
  }

  set {
    name  = "controller.env[4].name"
    value = "GITOPS_CHART_PATH"
  }

  set {
    name  = "controller.env[4].value"
    value = var.gitops_chart_path
  }
}
