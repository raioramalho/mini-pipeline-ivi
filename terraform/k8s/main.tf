resource "kubernetes_deployment" "api" {
  metadata {
    name = "mini-api"
    labels = {
      app = "mini-api"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mini-api"
      }
    }
    template {
      metadata {
        labels = {
          app = "mini-api"
        }
      }
      spec {
        container {
          name  = "api"
          image = "mini-api"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "api" {
  metadata {
    name = "mini-api"
  }
  spec {
    selector = {
      app = kubernetes_deployment.api.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "minio" {
  metadata {
    name = "minio"
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
          image = "minio/minio"
          args  = ["server", "/data"]
          env {
            name  = "MINIO_ACCESS_KEY"
            value = "admin"
          }
          env {
            name  = "MINIO_SECRET_KEY"
            value = "admin123"
          }
          port {
            container_port = 9000
          }
        }
      }
    }
  }
}

resource "kubernetes_job" "processor" {
  metadata {
    name = "csv-processor"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name  = "processor"
          image = "mini-processor"
          command = ["python", "process.py"]
        }
        restart_policy = "Never"
      }
    }
  }
}

resource "kubernetes_ingress_v1" "api" {
  metadata {
    name = "mini-api-ingress"
  }
  spec {
    rule {
      host = var.ingress_host
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.api.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

variable "ingress_host" {
  type    = string
  default = "mini.local"
}
