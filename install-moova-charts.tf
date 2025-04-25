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
  debug = true
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "docker-desktop"
  }
  registries = [
    {
      url       = "oci://moovaregistry.almaviva.it:5050/gitlab-instance-a5bf24f7/moova"
      username  = "root"
      password  = "dtE5sPAA9scGYCn56qzh"      
    }
  ]
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

resource "kubernetes_namespace" "ns-moova" {
  metadata {
    name = "ns-moova-terraform"
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  create_namespace  = true

  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
    /*
      Nel caso in cui l’installazione avvenga su EKS con CNI custom
    {
      name  = "webhook.hostNetwork"
      value = "true"
    },
    {
      name  = "webhook.securePort"
      value = "10251"
    }
  */
  ]
}

resource "helm_release" "prerequisiti" {
  name        = "prerequisiti"
  chart       = "oci://moovaregistry.almaviva.it:5050/gitlab-instance-a5bf24f7/moova/prerequisiti"
  namespace   = "kube-system"

  set = [
    {
      name  = "certManager.selfSigned"
      value = "true"
    }
  ]
}
