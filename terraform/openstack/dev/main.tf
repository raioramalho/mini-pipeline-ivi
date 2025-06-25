provider "openstack" {
  auth_url    = var.auth_url
  tenant_name = var.tenant_name
  domain_name = var.domain_name
  user_name   = var.user_name
  password    = var.password
  region      = var.region
}

# 📦 Criação do bucket Swift
resource "openstack_objectstorage_container_v1" "bucket" {
  name         = var.bucket_name
  content_type = "application/json"
  metadata = {
    app = "mini-pipeline"
  }
}

# 🐳 Deploy no cluster Kubernetes (Magnum) usando kubectl apply
resource "null_resource" "deploy_to_k8s" {
  provisioner "local-exec" {
    command = <<EOT
      export KUBECONFIG=${path.module}/kubeconfig.yaml
      kubectl apply -f ${path.module}/k8s/deployment.yaml
      kubectl apply -f ${path.module}/k8s/service.yaml
    EOT
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    openstack_objectstorage_container_v1.bucket
  ]
}
