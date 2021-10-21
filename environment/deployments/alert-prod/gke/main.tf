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
    cluster_name     = "${var.application_name}-${var.environment}"
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

module "firewall" {
  # Permit tcp/8443 from the cluster master nodes so that nginx ingress
  # controller can use admission webhooks.
  #
  # https://github.com/kubernetes/kubernetes/issues/79739
  source = "../../../../modules/firewall"

  network    = var.network_name
  project_id = local.project_id

  custom_rules = {
    gke_admission_webooks = {
      description          = "Deployed with Terraform"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = [local.master_ipv4_cidr_block]
      targets              = [module.gke.name]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = ["8443"]
        },
      ]
      extra_attributes = {}
    }
  }
}
