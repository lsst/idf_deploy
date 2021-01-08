module "mysql-db" {
  source                          = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version                         = "~> 4.0"
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
  maintenance_window_day          = var.maintenance_window_day
  maintenance_window_hour         = var.maintenance_window_hour
  maintenance_window_update_track = var.maintenance_window_update_track
  pricing_plan                    = var.pricing_plan
  user_host                       = var.user_host
  user_labels                     = var.user_labels
  user_name                       = var.user_name
  user_password                   = var.user_password
  deletion_protection             = var.deletion_protection
  database_flags                  = var.database_flags

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
    authorized_networks = var.authorized_networks
  }
}