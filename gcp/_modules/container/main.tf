# ---------------------------------------------------------------------
# Container
# ---------------------------------------------------------------------
resource "google_container_cluster" "TerraFailContainer_cluster" {
  # Drata: Configure [google_container_cluster.node_config.labels] to ensure that organization-wide label conventions are followed.
  name                    = "TerraFailContainer_cluster"
  initial_node_count      = 3
  enable_kubernetes_alpha = true
  enable_shielded_nodes   = false
  enable_legacy_abac      = false
  binary_authorization {
    evaluation_mode = "DISABLED"
  }
  database_encryption {
    state    = "ENCRYPTED"
    key_name = "projects/my-project/locations/global/keyRings/my-ring/cryptoKeys/my-key"
  }
  node_config {
    disk_size_gb = 10
    image_type   = "UBUNTU_CONTAINERD"
  }
  datapath_provider = "LEGACY_DATAPATH"
  network_policy {
    provider = "PROVIDER_UNSPECIFIED"
    enabled  = true
  }
}

resource "google_container_node_pool" "TerraFailContainer_node_pool" {
  # Drata: Configure [google_container_node_pool.node_config.labels] to ensure that organization-wide label conventions are followed.
  name       = "TerraFailContainer_node_pool"
  cluster    = google_container_cluster.TerraFailContainer_cluster.name
  node_count = 1
  node_config {
    disk_size_gb = 10
    image_type   = "UBUNTU_CONTAINERD"
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
