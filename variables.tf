variable "helm_namespace" {}

variable "helm_repository" {
  default = "https://statcan.github.io/charts"
}

variable "helm_repository_password" {
  default = ""
}

variable "helm_repository_username" {
  default = ""
}

variable "chart_version" {
  default = "0.0.5"
}

variable "argocd_projects" {
  description = "Defines a list of ArgoCD Projects to deploy."
  type = list(object({
    name           = string
    namespace      = string
    classification = string
    spec = object({
      oidcConfig = object({
        name         = string
        issuer       = string
        clientID     = string
        clientSecret = string
        requestedIDTokenClaims = object({
          groups = object({
            essential = bool
          })
        })
        requestedScopes = list(string)
      })
      rbac = object({
        defaultPolicy = string
        policy        = string
        scopes        = string
      })
      server = object({
        autoscale = object({
          enabled = bool
        })
        host     = string
        insecure = bool
      })
    })
  }))
}
