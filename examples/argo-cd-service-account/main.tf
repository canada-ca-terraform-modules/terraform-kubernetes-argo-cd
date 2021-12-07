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

module "argo_cd_service_account" {
  source = "../../"

  depends_on     = [resource.kubernetes_namespace.argo_cd_system]
  helm_namespace = "argo-cd-system"

  projects = [
    {
      name           = "argo-cd-system"
      namespace      = "argo-cd-system"
      classification = "unclassified"
      spec = {
        image = {
          repository = "argoproj/argocd"
          tag        = "sha256:0bbcd97134f2d7c28293d4b717317f32aaf8fa816a1ffe764c1ebc390c4646d3"
        },
        kustomizeBuildOptions = "--load-restrictor LoadRestrictionsNone --enable-helm",
        oidcConfig = {
          name         = ""
          issuer       = ""
          clientID     = ""
          clientSecret = ""
          requestedIDTokenClaims = {
            groups = {
              essential = true
            }
          }
          requestedScopes = ["openid", "profile", "email"]
        },
        rbac = {
          defaultPolicy = "role:readonly"
          policy        = <<EOT
            p, role:org-admin, applications, *, */*, allow
            p, role:org-admin, clusters, get, *, allow
            p, role:org-admin, repositories, get, *, allow
            p, role:org-admin, repositories, create, *, allow
            p, role:org-admin, repositories, update, *, allow
            p, role:org-admin, repositories, delete, *, allow
            g, "xxxxx-xxxx-xxxx-xxxx-xxxxx", role:org-admin
          EOT
          scopes        = "[groups]"
        },
        server = {
          autoscale = {
            enabled = true
          }
          host     = "argo-cd-system.example.ca"
          insecure = true
        }
      }
    }
  ]

  values = <<EOF
operator:
  clusterDomain: ""
  nsToWatch: "argo-cd-system"
  image:
    pullPolicy: IfNotPresent
EOF

}
