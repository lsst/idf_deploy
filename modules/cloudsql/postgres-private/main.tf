data "google_compute_network" "network" {
  name    = var.vpc_network
  project = var.project_id
}

module "cloudsql-db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 4.0"

  name                            = var.db_name
  random_instance_name            = var.random_instance_name
  database_version                = var.database_version
  project_id                      = var.project_id
  zone                            = var.zone
  region                          = var.region
  tier                            = var.tier
  disk_size                       = var.disk_size
  disk_type                       = var.disk_type
  backup_configuration            = var.backup_configuration
  disk_autoresize                 = var.disk_autoresize
  enable_default_db               = var.enable_default_db
  enable_default_user             = var.enable_default_user
  maintenance_window_day          = var.maintenance_window_day
  maintenance_window_hour         = var.maintenance_window_hour
  maintenance_window_update_track = var.maintenance_window_update_track
  pricing_plan                    = var.pricing_plan
  create_timeout                  = var.create_timeout
  update_timeout                  = var.update_timeout

  additional_databases = var.additional_databases
  additional_users     = var.additional_users

  user_labels         = var.user_labels
  user_name           = var.user_name
  user_password       = var.user_password
  deletion_protection = var.deletion_protection
  database_flags      = var.database_flags

  ip_configuration = {
    ipv4_enabled        = var.ipv4_enabled
    private_network     = data.google_compute_network.network.self_link
    require_ssl         = var.require_ssl
    authorized_networks = var.authorized_networks
  }
}

module "private-service-access" {
  source = "../private_service_access"

  project_id    = var.project_id
  vpc_network   = var.vpc_network
  address       = var.address
  prefix_length = var.prefix_length
  ip_version    = var.ip_version
  labels        = var.labels
}

module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project_id
  display_name  = var.display_name
  description   = var.description
  prefix        = var.prefix
  names         = var.names
  project_roles = var.project_roles
}
