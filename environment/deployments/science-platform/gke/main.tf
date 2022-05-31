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
  network_policy         = var.network_policy
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
  }

  node_pools_taints = var.node_pools_taints
}

module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"

  project_id    = local.project_id
  display_name  = "HiPS web service"
  description   = "Terraform-managed service account for GCS access"
  names         = ["crawlspace-hips"]
}

resource "google_service_account_iam_binding" "hips-iam-binding" {
  service_account_id = module.service_accounts.service_accounts_map["crawlspace-hips"].name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${local.project_id}.svc.id.goog[hips/hips]",
  ]
}
