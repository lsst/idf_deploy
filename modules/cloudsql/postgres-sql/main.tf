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
    private_network     = var.private_network
    require_ssl         = true
    authorized_networks = var.authorized_networks
  }
}
