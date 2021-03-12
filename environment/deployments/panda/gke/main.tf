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

data "google_compute_subnetwork" "subnetwork_2" {
  name    = "subnet-us-central1-02"
  region  = "us-central1"
  project = local.project_id
}

data "google_compute_subnetwork" "subnetwork_3" {
  name    = "subnet-us-central1-03"
  region  = "us-central1"
  project = local.project_id
}

# ----------------------------------------
#   GKE
# ----------------------------------------

locals {
  project_id   = data.google_projects.host_project.projects[0].project_id
  network      = data.google_compute_network.network.name
  subnetwork   = data.google_compute_subnetwork.subnetwork.name
  subnetwork_2 = data.google_compute_subnetwork.subnetwork_2.name
  subnetwork_3 = data.google_compute_subnetwork.subnetwork_3.name
}

module "gke" {
  source = "../../../../modules/gke"

  # Cluster
  name                   = "moderatemem"
  project_id             = local.project_id
  network                = var.network_name
  subnetwork             = local.subnetwork
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  release_channel        = var.release_channel
  node_pools             = var.node_pools
  network_policy         = var.network_policy
  gce_pd_csi_driver      = var.gce_pd_csi_driver
  cluster_telemetry_type = var.cluster_telemetry_type
  cluster_autoscaling    = var.cluster_autoscaling_1

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
}

module "gke_2" {
  source = "../../../../modules/gke"

  # Cluster
  name                   = "highmem"
  project_id             = local.project_id
  network                = var.network_name
  subnetwork             = local.subnetwork_2
  master_ipv4_cidr_block = var.master_ipv4_cidr_block_2
  release_channel        = var.release_channel
  node_pools             = var.node_pools_2
  network_policy         = var.network_policy
  gce_pd_csi_driver      = var.gce_pd_csi_driver
  cluster_telemetry_type = var.cluster_telemetry_type
  zones                  = var.zones
  cluster_autoscaling    = var.cluster_autoscaling_2

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = local.subnetwork_2
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }
}

module "gke_dev" {
  source = "../../../../modules/gke"

  # Cluster
  name                   = "developmentcluster"
  project_id             = local.project_id
  network                = var.network_name
  subnetwork             = local.subnetwork_3
  master_ipv4_cidr_block = var.master_ipv4_cidr_block_3
  release_channel        = var.release_channel
  node_pools             = var.node_pools_2
  network_policy         = var.network_policy
  gce_pd_csi_driver      = var.gce_pd_csi_driver
  cluster_telemetry_type = var.cluster_telemetry_type
  zones                  = var.zones

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = local.subnetwork_3
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }
}



