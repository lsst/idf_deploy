# ----------------------------------------
#   RETRIEVE PROJECT NAME BASED ON FILTERS
# ----------------------------------------

data "google_projects" "host_project" {
  filter = "labels.application_name=${var.application_name} labels.environment=${var.environment}"
}

data "google_compute_network" "network" {
  name    = var.network_name
  project = local.project_id
}

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
  network    = data.google_compute_network.network.name
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
  release_channel        = var.release_channel
  node_pools             = var.node_pools
  network_policy         = var.network_policy
  gce_pd_csi_driver      = var.gce_pd_csi_driver
  cluster_telemetry_type = var.cluster_telemetry_type
  maintenance_start_time = var.maintenance_start_time
  maintenance_end_time   = var.maintenance_end_time
  maintenance_recurrence = var.maintenance_recurrence


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

    czar-pool = {
      tier = "czar"
    }

    worker-pool = {
      tier = "worker"
    }
  }
}