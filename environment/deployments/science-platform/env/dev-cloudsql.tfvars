# Project
environment      = "dev"
application_name = "science-platform"
project_id       = "science-platform-dev-7696"

# Butler Registry Original Database
butler_registry_db_name          = "butler-registry-dev"
butler_registry_database_version = "POSTGRES_13"
butler_registry_require_ssl      = false
butler_registry_database_flags = [
  { name = "password_encryption", value = "scram-sha-256" }
]
butler_registry_ipv4_enabled                           = true
butler_registry_db_maintenance_window_day              = 1
butler_registry_db_maintenance_window_hour             = 23
butler_registry_db_maintenance_window_update_track     = "canary"
butler_registry_backups_enabled                        = true
butler_registry_backups_point_in_time_recovery_enabled = true

# Butler Registry DP02 Database
butler_registry_dp02_db_name          = "butler-registry-dp02-dev"
butler_registry_dp02_database_version = "POSTGRES_16"
butler_registry_dp02_tier             = "db-custom-2-7680"
butler_registry_dp02_require_ssl      = false
butler_registry_dp02_disk_size        = 700
butler_registry_dp02_database_flags = [
  { name = "max_connections", value = "400" },
  { name = "password_encryption", value = "scram-sha-256" }
]
butler_registry_dp02_edition                                = "ENTERPRISE"
butler_registry_dp02_ipv4_enabled                           = false
butler_registry_dp02_ssl_mode                               = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
butler_registry_dp02_db_maintenance_window_day              = 1
butler_registry_dp02_db_maintenance_window_hour             = 23
butler_registry_dp02_db_maintenance_window_update_track     = "stable"
butler_registry_dp02_backups_enabled                        = false
butler_registry_dp02_backups_point_in_time_recovery_enabled = false

# Science Platform Database
science_platform_db_maintenance_window_day          = 1
science_platform_db_maintenance_window_hour         = 22
science_platform_db_maintenance_window_update_track = "canary"
science_platform_backups_enabled                    = true

# Increase this number to force Terraform to update the dev environment.
# Serial: 19
