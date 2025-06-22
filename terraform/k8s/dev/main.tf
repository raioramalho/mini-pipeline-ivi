variable "namespace" {
  type    = string
  default = "default"
}

variable "image_env" {
  description = "Ambiente da imagem (dev, homolog, prod)"
  default = "${var.image_env}"
  type        = string
}

resource "kubernetes_deployment" "minio" {
  metadata {
    name      = "minio"
    namespace = var.namespace
    labels = {
      app = "minio"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "minio"
      }
    }

    template {
      metadata {
        labels = {
          app = "minio"
        }
      }

      spec {
        container {
          name  = "minio"
          image = "quay.io/minio/minio:latest"
          args  = ["server", "/data"]
          env {
            name  = "MINIO_ACCESS_KEY"
            value = "minioadmin"
          }
          env {
            name  = "MINIO_SECRET_KEY"
            value = "minioadmin"
          }
          port {
            container_port = 9000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "minio" {
  metadata {
    name      = "minio"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "minio"
    }
    port {
      port        = 9000
      target_port = 9000
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "api" {
  metadata {
    name      = "mini-pipeline-ivi"
    namespace = var.namespace
    labels = {
      app = "api"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "api"
      }
    }

    template {
      metadata {
        labels = {
          app = "api"
        }
      }

      spec {
        service_account_name = "api-sa"

        container {
          name  = "api"
          image = "ghcr.io/raioramalho/mini-pipeline-ivi-${var.image_env}:latest"

          port {
            container_port = 8000
          }
        }

        image_pull_secrets {
          name = "ghcr-pull-secret"
        }
      }
    }
  }
}

resource "kubernetes_service" "api" {
  metadata {
    name      = "mini-pipeline-ivi"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "api"
    }
    port {
      port        = 8000
      target_port = 8000
    }
    type = "ClusterIP"
  }
}
