# Name of the Helm Namespace
output "helm_namespace" {
  value = module.argo_cd_service_account.helm_namespace
}
