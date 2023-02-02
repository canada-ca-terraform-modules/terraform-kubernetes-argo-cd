# Variables

###############
### General ###
###############

variable "helm_namespace" {}

variable "helm_repository" {
  default     = "https://statcan.github.io/charts"
  description = "The repository where the Helm chart is stored"
}

variable "helm_repository_password" {
  type        = string
  nullable    = false
  default     = ""
  description = "The password of the repository where the Helm chart is stored"
  sensitive   = true
}

variable "helm_repository_username" {
  type        = string
  nullable    = false
  default     = ""
  description = "The username of the repository where the Helm chart is stored"
  sensitive   = true
}

variable "helm_chart_version" {
  default = "0.4.0"
}

variable "helm_values" {
  default = ""
  type    = string
}
