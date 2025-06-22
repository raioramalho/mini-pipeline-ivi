##########################
# Locais Dinâmicos
##########################

locals {  
  image_tag      = "ghcr.io/raioramalho/mini-pipeline-ivi-${var.current_branch}:latest"
}

##########################
# API FastAPI
##########################

resource "kubernetes_deployment" "mini_pipeline_api" {
  metadata {
    name      = "mini-pipeline-api"
    namespace = "default"
    labels = {
      app = "mini-pipeline-api"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mini-pipeline-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "mini-pipeline-api"
        }
      }

      spec {
        image_pull_secrets {
          name = "ghcr-secret"
        }

        container {
          name  = "mini-pipeline-api"
          image = local.image_tag

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mini_pipeline_api" {
  metadata {
    name      = "mini-pipeline-api"
    namespace = "default"
  }

  spec {
    selector = {
      app = "mini-pipeline-api"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

##########################
# MinIO
##########################

resource "kubernetes_deployment" "minio" {
  metadata {
    name      = "minio"
    namespace = "default"
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
          image = "minio/minio:latest"
          args  = ["server", "/data"]

          env {
            name  = "MINIO_ROOT_USER"
            value = "minio"
          }

          env {
            name  = "MINIO_ROOT_PASSWORD"
            value = "minio123"
          }

          port {
            container_port = 9000
          }

          port {
            container_port = 9001
          }

          volume_mount {
            name       = "minio-data"
            mount_path = "/data"
          }
        }

        volume {
          name = "minio-data"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "minio" {
  metadata {
    name      = "minio"
    namespace = "default"
  }

  spec {
    selector = {
      app = "minio"
    }

    port {
      name        = "api"
      port        = 9000
      target_port = 9000
    }

    port {
      name        = "console"
      port        = 9001
      target_port = 9001
    }

    type = "ClusterIP"
  }
}

##########################
# Outputs úteis
##########################

output "image_usada_na_api" {
  value = local.image_tag
}
