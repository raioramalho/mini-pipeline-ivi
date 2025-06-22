variable "kubernetes_config_path" {
  type        = string
  description = "Path to the Kubernetes config file"
  default     = "~/.kube/local"
}

variable "kubernetes_token" {
  type = string
}

variable "current_branch" {
  description = "Branch atual usada na tag da imagem"
  type        = string
}

variable "tls_insecure" {
  type        = bool
  description = "Use TLS for Kubernetes provider"
  default     = false
}
