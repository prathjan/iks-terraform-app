# Intersight Provider Information
terraform {
  required_providers {
#    intersight = {
#      source = "CiscoDevNet/intersight"
#      version = "1.0.2"
#    }
    helm = {
      source = "hashicorp/helm"
      version = "2.0.3"
    }
  }
}


provider "intersight" {
  apikey        = var.api_key_id
  secretkey = var.api_private_key
  endpoint      = var.api_endpoint
}

data "intersight_kubernetes_cluster" "ikscluster" {
  name  = var.iksclustername
  moid = ""
}

provider "helm" {
  kubernetes {
    host = var.host 
    client_certificate = var.clcert 
    client_key = var.clkey 
    cluster_ca_certificate = var.cacert 
#    host = local.kube_config.clusters[0].cluster.server
#    client_certificate = base64decode(local.kube_config.users[0].user.client-certificate-data)
#    client_key = base64decode(local.kube_config.users[0].user.client-key-data)
#    cluster_ca_certificate = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
  }
}


variable "api_private_key" {
  type = string
}

variable "api_key_id" {
  type = string
}

variable "api_endpoint" {
  default = "https://www.intersight.com"
}

variable "iksclustername" {
  type = string
}

#locals {
#  kube_config = yamldecode(base64decode(data.intersight_kubernetes_cluster.ikscluster.results[0].kube_config))
#}

resource helm_release nginx_ingress {
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

