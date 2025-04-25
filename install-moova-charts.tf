terraform {
  required_providers {
    helm = {
      source = "opentofu/helm"
    }
    kubernetes = {
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "docker-desktop"
  }
  registries = [
    {
      url     = ""
    }
  ]
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "ns-moova-terraform"
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "my-first-namespace"
}
