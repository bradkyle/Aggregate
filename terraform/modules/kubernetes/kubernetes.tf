// Set up the Kubernetes provider with the values supplied above
provider "kubernetes" {
  host     = "${google_container_cluster.axiom_cluster.endpoint}"
  username = "${google_container_cluster.axiom_cluster.master_auth.0.username}"
  password = "${google_container_cluster.axiom_cluster.master_auth.0.password}"
  client_certificate     = "${google_container_cluster.axiom_cluster.master_auth.0.client_certificate}"
  client_key             = "${google_container_cluster.axiom_cluster.master_auth.0.client_key}"
  cluster_ca_certificate = "${google_container_cluster.axiom_cluster.master_auth.0.cluster_ca_certificate}"
}

// Kubernetes namespace specification
resource "kubernetes_namespace" "nodered_namespace" {
  metadata {
    name = "nodered"
  }
}

// Set up  a kubernetes pod with the image supplied above
resource "kubernetes_pod" "nodered_pod" {
  metadata {
    name = "nodered-pod"
    namespace="${kubernetes_namespace.nodered_namespace.metadata.0.name}"
    labels {
      App = "nodered"
    }
  }

  spec {
    container {
      image = "${data.google_container_registry_image.nodered.image_url}"
      name  = "nodered"
      args = ["-listen=:1880"]
      port {
        container_port = 1880
      }
    }
  }
}

resource "kubernetes_service" "nodered_lb" {
  metadata {
    name = "nodered-lb"
    namespace="${kubernetes_namespace.nodered_namespace.metadata.0.name}"
  }

  spec {
    selector {
      App = "${kubernetes_pod.nodered_pod.metadata.0.labels.App}"
    }

    port {
      port        = 1880
      target_port = 1880
    }

    type = "LoadBalancer"
  }
}


output "lb_ip" {
  value = "${kubernetes_service.nodered_lb.load_balancer_ingress.0.ip}"
}
