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

# ----------------------------------------
#   CloudSQL
# ----------------------------------------

resource "random_password" "gafaelfawr" {
  length  = 24
  number  = true
  upper   = true
  special = false
}

module "postgres" {
  source = "../../../../modules/cloudsql/postgres-sql"

  authorized_networks             = []
  database_version                = var.database_version
  db_name                         = "${var.application_name}-${var.environment}"
  deletion_protection             = true
  enable_default_db               = false
  enable_default_user             = false
  maintenance_window_day          = var.db_maintenance_window_day
  maintenance_window_hour         = var.db_maintenance_window_hour
  maintenance_window_update_track = var.db_maintenance_window_update_track
  project_id                      = local.project_id
  random_instance_name            = true
  ipv4_enabled                    = false
  private_network                 = local.network

  additional_databases = [
    {
      name      = "gafaelfawr"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    }
  ]

  additional_users = [
    {
      name     = "gafaelfawr"
      password = random_password.gafaelfawr.result
    }
  ]

  database_flags = [
    {
      name  = "password_encryption"
      value = "scram-sha-256"
    }
  ]
}

module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"

  project_id    = local.project_id
  display_name  = "PostgreSQL client"
  description   = "Terraform-managed service account for PostgreSQL access"
  names         = ["gafaelfawr"]
  project_roles = ["${local.project_id}=>roles/cloudsql.client"]
}
