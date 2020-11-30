# ------------------------------------------------------------
#   BACKEND BLOCK
# ------------------------------------------------------------

terraform {
  required_providers {
    google-beta = "~> 3.0"
    google      = "~> 3.0"
  }
}


# ------------------------------------------------------------
#   CLUSTER BLOCK
# ------------------------------------------------------------

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version = "~> 12.0"

  project_id = var.project_id
  name       = "${var.name}-cluster"
  region     = var.region
  zones      = var.zones
  network    = var.network
  subnetwork = var.subnetwork  

  ip_range_pods                      = var.ip_range_pods
  ip_range_services                  = var.ip_range_services
  logging_service                    = var.logging_service
  monitoring_service                 = var.monitoring_service
  maintenance_start_time             = var.maintenance_start_time
  create_service_account             = var.create_service_account
  enable_resource_consumption_export = var.enable_resource_consumption_export
  skip_provisioners                  = var.skip_provisioners
  http_load_balancing                = var.http_load_balancing
  horizontal_pod_autoscaling         = var.horizontal_pod_autoscaling
  network_policy                     = var.network_policy
  enable_private_nodes               = var.enable_private_nodes
  master_ipv4_cidr_block             = var.master_ipv4_cidr_block
  remove_default_node_pool           = var.remove_default_node_pool
  enable_shielded_nodes	             = var.enable_shielded_nodes
  cluster_resource_labels            = var.cluster_resource_labels

  node_pools = [
    {
      name               = var.node_pool_1_name
      machine_type       = var.node_pool_1_machine_type
      min_count          = var.node_pool_1_min_count
      max_count          = var.node_pool_1_max_count
      local_ssd_count    = var.node_pool_1_local_ssd_count
      auto_repair        = var.node_pool_1_auto_repair
      auto_upgrade       = var.node_pool_1_auto_upgrade
      preemptible        = var.node_pool_1_preemptible
      initial_node_count = var.node_pool_1_initial_node_count
    },
  ]

}