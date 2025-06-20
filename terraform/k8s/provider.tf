provider "kubernetes" {
  config_path = var.kubeconfig_path
}

variable "kubeconfig_path" {
  type    = string
  default = "~/.kube/config"
}
