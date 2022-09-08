terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0.0"
    }
  }
  required_version = "~> 1.0.9"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "argocd_operator_system" {
  metadata {
    name = "argocd-operator-system"
  }
}

resource "kubernetes_namespace" "argo_cd_system" {
  metadata {
    name = "argo-cd-system"
  }
}

module "argo_cd_operator" {
  source = "../../"

  depends_on     = [resource.kubernetes_namespace.argo_cd_system]
  helm_namespace = "argo-cd-system"

  helm_values = <<EOF
operator:
  clusterDomain: ""
  nsToWatch: "argo-cd-system"
  image:
    pullPolicy: IfNotPresent
EOF

}
