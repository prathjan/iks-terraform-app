provider "helm" {
  kubernetes {
    config_path = "/home/terraform/.kube/config" 
  }
}

variable "host" {
  type = string
}
variable "cluster" {
  type = string
}
variable "certauthdata" {
  type = string
}
variable "user" {
  type = string
}
variable "context" {
  type = string
}
variable "clientcertdata" {
  type = string
}
variable "clientkeydata" {
  type = string
}

locals {
 kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${var.certauthdata} 
    server: ${var.host}
  name: ${var.cluster}
contexts:
- context:
    cluster: ${var.cluster}
    user: ${var.user}
  name: ${var.context}
current-context: ${var.context}
kind: Config
preferences: {}
users:
- name: ${var.user}
  user:
    client-certificate-data: ${var.clientcertdata} 
    client-key-data: ${var.clientkeydata}
KUBECONFIG
}

resource "local_file" "kubeconfig" {
  content  = local.kubeconfig
  filename = "/home/terraform/.kube/config"
}


resource helm_release nginx_ingress {
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

