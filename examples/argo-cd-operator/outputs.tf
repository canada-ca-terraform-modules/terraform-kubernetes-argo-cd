# Name of the Helm Namespace
output "helm_namespace" {
  value = module.argo_cd_operator.helm_namespace
}
