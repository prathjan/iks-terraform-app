# Intersight Provider Information
#terraform {
#  required_providers {
#    intersight = {
#      source = "CiscoDevNet/intersight"
#      version = "1.0.3"
#    }
#  }
#}


data "terraform_remote_state" "iksws" {
  backend = "remote"
  config = {
    organization = "CiscoDevNet"
    workspaces = {
      name = "sandbox2"
    }
  }
}




#provider "intersight" {
#  apikey        = var.api_key_id
#  secretkey = var.api_private_key
#  endpoint      = var.api_endpoint
#}

#data "intersight_kubernetes_cluster" "ikscluster" {
#  name  = var.iksclustername
#  moid = ""
#}

#provider "helm" {
#  kubernetes {
#    host = local.kube_config.clusters[0].cluster.server
#    client_certificate = base64decode(local.kube_config.users[0].user.client-certificate-data)
#    client_key = base64decode(local.kube_config.users[0].user.client-key-data)
#    cluster_ca_certificate = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
#  }
#}



#provider "helm" {
# kubernetes {
#  host = data.terraform_remote_state.iksws.outputs.kube_config.clusters[0].cluster.server
#  client_certificate = base64decode(data.terraform_remote_state.iksws.outputs.kube_config.users[0].user.client-certificate-data)
#  client_key = base64decode(data.terraform_remote_state.iksws.outputs.kube_config.users[0].user.client-key-data)
#  cluster_ca_certificate = base64decode(data.terraform_remote_state.iksws.outputs.kube_config.clusters[0].cluster.certificate-authority-data)
# }
#}


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
#  kube_config = yamldecode(base64decode(data.terraform_remote_state.iksws.outputs.kube_config))
  #kube_config = yamldecode(base64decode(data.intersight_kubernetes_cluster.ikscluster.results[0].kube_config))
#}


resource helm_release nginx_ingress {
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}






provider "helm" {
  kubernetes {
    #config_path = "/tmp/config"
    host = local.kube_config.clusters[0].cluster.server
    client_certificate = base64decode(local.kube_config.users[0].user.client-certificate-data)
    client_key = base64decode(local.kube_config.users[0].user.client-key-data)
    cluster_ca_certificate = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
  }
}



locals {
  #content  = base64decode(data.intersight_kubernetes_cluster.ikscluster.kube_config)
  kube_config = yamldecode(base64decode(data.terraform_remote_state.iksws.outputs.kube_config))
  #filename = "/tmp/config"
}


