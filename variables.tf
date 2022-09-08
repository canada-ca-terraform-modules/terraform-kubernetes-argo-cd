# Variables

###############
### General ###
###############

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

variable "helm_chart_version" {
  default = "0.1.2"
}

variable "helm_values" {
  default = ""
  type    = string
}
