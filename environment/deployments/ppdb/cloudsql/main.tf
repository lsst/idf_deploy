
data "terraform_remote_state" "ppdb_project" {
  backend = "gcs"

  config = {
    prefix = "${var.application_name}/${var.environment}"
    bucket = var.state_bucket
  }
}


# Sets up a connection from the VPC to Google services
module "private-service-access" {
  source = "../../../../modules/cloudsql/private_service_access"

  project_id  = data.terraform_remote_state.ppdb_project.outputs.project_id
  vpc_network = data.terraform_remote_state.ppdb_project.outputs.network_name
}

module "db_ppdb" {
  source                                        = "../../../../modules/cloudsql/postgres-sql"
  db_name                                       = "${var.application_name}-${var.environment}"
  database_version                              = var.ppdb_cloud_sql_database_version
  deletion_protection                           = true
  tier                                          = var.ppdb_cloud_sql_tier
  database_flags                                = var.ppdb_cloud_sql_database_flags
  data_cache_enabled                            = var.ppdb_cloud_sql_data_cache_enabled
  disk_size                                     = var.ppdb_cloud_sql_disk_size
  enable_default_db                             = false
  enable_default_user                           = false
  edition                                       = var.ppdb_cloud_sql_edition
  maintenance_window_day                        = var.ppdb_cloud_sql_db_maintenance_window_day
  maintenance_window_hour                       = var.ppdb_cloud_sql_db_maintenance_window_hour
  maintenance_window_update_track               = var.ppdb_cloud_sql_db_maintenance_window_update_track
  random_instance_name                          = false
  project_id                                    = data.terraform_remote_state.ppdb_project.outputs.project_id
  private_network                               = data.terraform_remote_state.ppdb_project.outputs.network_self_link
  enable_private_path_for_google_cloud_services = var.ppdb_cloud_sql_enable_private_path
  ipv4_enabled                                  = var.ppdb_cloud_sql_ipv4_enabled
  authorized_networks                           = var.ppdb_cloud_sql_authorized_networks
  ssl_mode                                      = var.ppdb_cloud_sql_ssl_mode

  backup_configuration = {
    enabled                        = var.ppdb_cloud_sql_backups_enabled
    start_time                     = var.ppdb_cloud_sql_backups_start_time
    location                       = "us-central1"
    point_in_time_recovery_enabled = var.ppdb_cloud_sql_backups_point_in_time_recovery_enabled
  }

  additional_databases = [
    {
      name      = "ppdb-chunk-tracking"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    }
  ]
}
