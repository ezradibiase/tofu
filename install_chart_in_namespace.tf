terraform {
  required_providers {
    helm = {
      source = "opentofu/helm"
      version = "3.0.0-pre2"
    }
    kubernetes = {
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "ArgoLab"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "ArgoLab"
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "my-first-namespace"
  }
}

resource "helm_release" "grafana" {
  name       = "ezra-grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "my-first-namespace"
}
