resource "helm_release" "argocd_operator" {
  name = "argocd-operator"

  repository          = var.helm_repository
  repository_username = var.helm_repository_username
  repository_password = var.helm_repository_password

  chart     = "argocd-operator"
  version   = var.chart_version
  namespace = var.helm_namespace
  timeout   = 1200

  values = [<<EOF
operator:
  clusterDomain: ""
  nsToWatch: "argocd-operator-system,daaas-system,org-ces-system,org-fdi-system,org-geo-system"
  image:
    repository: statcan/argocd-operator
    tag: v0.0.6
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

projects:
%{for project in var.argocd_projects~}
  - name: ${project.name}
    namespace: ${project.namespace}
    podLabels:
      data.statcan.gc.ca/classification: ${project.classification}
    spec:
      kustomizeBuildOptions: ${project.spec.kustomizeBuildOptions}
      oidcConfig:
        name: ${project.spec.oidcConfig.name}
        issuer: ${project.spec.oidcConfig.issuer}
        clientID: ${project.spec.oidcConfig.clientID}
        clientSecret: ${project.spec.oidcConfig.clientSecret}
        requestedIDTokenClaims:
          groups:
            essential: ${project.spec.oidcConfig.requestedIDTokenClaims.groups.essential}
        requestedScopes: ${jsonencode(project.spec.oidcConfig.requestedScopes)}
      rbac:
        defaultPolicy: ${project.spec.rbac.defaultPolicy}
        policy: ${jsonencode(project.spec.rbac.policy)}
        scopes: ${jsonencode(project.spec.rbac.scopes)}
      server:
        autoscale:
          enabled: ${project.spec.server.autoscale.enabled}
        host: ${project.spec.server.host}
        insecure: ${project.spec.server.insecure}
%{endfor~}
EOF
  ]
}
