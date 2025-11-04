# ----------------------------------------
#   RETRIEVE PROJECT NAME BASED ON FILTERS
# ----------------------------------------
// Get project name from label filter
data "google_projects" "host_project" {
  filter = "labels.application_name=${var.application_name} labels.environment=${var.environment}"
}

// Get Network
data "google_compute_network" "network" {
  name    = var.network_name
  project = local.project_id
}

// Get Subnetwork
data "google_compute_subnetwork" "subnetwork" {
  name    = "subnet-us-central1-01"
  region  = "us-central1"
  project = local.project_id
}

# ----------------------------------------
#   GKE
# ----------------------------------------

locals {
  project_id = data.google_projects.host_project.projects[0].project_id
  network    = data.google_compute_network.network.self_link
  subnetwork = data.google_compute_subnetwork.subnetwork.name
}

module "gke" {
  source = "../../../../modules/gke"

  # Cluster
  name                   = "${var.application_name}-${var.environment}"
  project_id             = local.project_id
  network                = var.network_name
  subnetwork             = local.subnetwork
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  node_pools             = var.node_pools
  release_channel        = var.release_channel
  gce_pd_csi_driver      = var.gce_pd_csi_driver
  gcs_fuse_csi_driver    = var.gcs_fuse_csi_driver
  network_policy         = var.network_policy
  maintenance_start_time = var.maintenance_start_time
  maintenance_end_time   = var.maintenance_end_time
  maintenance_recurrence = var.maintenance_recurrence

  enable_dataplane_v2 = var.enable_dataplane_v2

  monitoring_enabled_components        = var.monitoring_enabled_components
  monitoring_enable_managed_prometheus = var.monitoring_enable_managed_prometheus

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = local.subnetwork
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }

  node_pools_taints = var.node_pools_taints

  gke_backup_agent_config = var.gke_backup_agent_config
}

resource "google_gke_backup_backup_plan" "complete" {
  count = var.cluster_backup_plan != null ? 1 : 0

  name = "${module.gke.name}"
  cluster = module.gke.id
  project = local.project_id
  location = "us-central1"

  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }

  # If you destroy the associated cluster, terraform will try to destroy and
  # recreate this backup plan, which will also try to destroy all of the
  # backups associated with the plan. If we are trying to intentionally rebuild
  # a cluster, we will need to destroy it first, and we don't want this backup
  # plan destroyed.
  lifecycle {
    ignore_changes = [
      cluster,
      name,
    ]
  }
}
