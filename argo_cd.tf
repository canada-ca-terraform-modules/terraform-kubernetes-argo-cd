# Argo CD

###############
### Argo CD ###
###############

# A Release is an instance of a chart running in a Kubernetes cluster.
#
# https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release
#
resource "helm_release" "argo_cd" {
  name = "argo-cd"

  repository          = var.helm_repository
  repository_username = var.helm_repository_username
  repository_password = var.helm_repository_password

  chart     = "argocd-operator"
  version   = var.helm_chart_version
  namespace = var.helm_namespace
  timeout   = 1200

  values = [<<EOF
operator:
  clusterDomain: ""
  nsToWatch: ""
  image:
    repository: quay.io/argoprojlabs/argocd-operator
    tag: v0.4.0
    pullPolicy: IfNotPresent
  imagePullSecrets: []
  replicaCount: 1
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
    runAsNonRoot: true
    fsGroup: 1000
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
      ephemeral-storage: 500Mi
EOF

    , var.helm_values,
  ]
}
