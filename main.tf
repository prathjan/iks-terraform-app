provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

variable "kubeconfig" {
  type = string
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

