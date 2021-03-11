# Intersight Provider Information
terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "1.0.0"
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
    config_path = "/tmp/config" 
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

resource "local_file" "kubeconfig" {
  content  = base64decode(data.intersight_kubernetes_cluster.ikscluster.kube_config)
  filename = "/tmp/config"
}


resource helm_release nginx_ingress {
  depends_on = [local_file.kubeconfig]
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

