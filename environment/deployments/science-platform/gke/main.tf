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

# output "subnetwork_self_link" {
#     value = data.google_compute_network.network.subnetworks_self_links
# }

data "google_compute_subnetwork" "subnetwork" {
  name    = "subnet-us-central1-01"
  region  = "us-central1"
  project = local.project_id
  #self_link = data.google_compute_network.network.subnetworks_self_links[0]
  #self_link = "https://www.googleapis.com/compute/v1/projects/science-platform-int-dc5d/regions/us-central1/subnetworks/subnet-us-central1-01"
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
  node_pools             = var.node_pools

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
      infrastructure   = "ok"
      jupyterlab       = "ok"
      dask             = "ok"
    }
  }
}