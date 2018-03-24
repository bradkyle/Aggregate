// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

// Set up the google container cluster
resource "google_container_cluster" "axiom_cluster" {
  name = "axiom"
  zone = "${var.region}"
  initial_node_count = 1

  master_auth {
    username = "${var.cluster_user}"
    password = "${var.cluster_pass}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "client_certificate" {
  value = "${google_container_cluster.axiom_cluster.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.axiom_cluster.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.axiom_cluster.master_auth.0.cluster_ca_certificate}"
}

output "cluster_username" {
  value = "${google_container_cluster.axiom_cluster.master_auth.0.username}"
}

output "cluster_password" {
  value = "${google_container_cluster.axiom_cluster.master_auth.0.password}"
}

output "endpoint" {
  value = "${google_container_cluster.axiom_cluster.endpoint}"
}

output "instance_group_urls" {
  value = "${google_container_cluster.axiom_cluster.instance_group_urls}"
}

output "node_config" {
  value = "${google_container_cluster.axiom_cluster.node_config}"
}

output "node_pools" {
  value = "${google_container_cluster.axiom_cluster.node_pool}"
}

// Get the image from Google Container Registry
data "google_container_registry_image" "nodered" {
    name = "nodered"
}

output "gcr_image_location" {
    value = "${data.google_container_registry_image.nodered.image_url}"
}

// Google conmpute engine disk for kubernetes persistence
resource "google_compute_disk" "default" {
  name  = "nodered-pv-disk"
  type  = "pd-ssd"
  zone  = "${var.region}"
  image = "debian-8-jessie-v20170523"
}
