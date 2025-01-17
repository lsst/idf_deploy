# Project
environment      = "int"
application_name = "science-platform"
project_id       = "science-platform-int-dc5d"

# Butler Registry Original Database
butler_registry_db_name          = "butler-registry-int"
butler_registry_database_version = "POSTGRES_13"
butler_registry_require_ssl      = false
butler_registry_database_flags = [
  { name = "temp_file_limit", value = 1049000000 },
  { name = "password_encryption", value = "scram-sha-256" }
]
butler_registry_ipv4_enabled                           = true
butler_registry_db_maintenance_window_update_track     = "canary"
butler_registry_backups_enabled                        = true
butler_registry_backups_point_in_time_recovery_enabled = true

# Butler Registry DP02 Database
butler_registry_dp02_db_name          = "butler-registry-dp02-int"
butler_registry_dp02_tier             = "db-custom-2-7680"
butler_registry_dp02_db_maintenance_window_day              = 2
butler_registry_dp02_db_maintenance_window_hour             = 23
butler_registry_dp02_db_maintenance_window_update_track     = "stable"
butler_registry_dp02_backups_enabled                        = false
butler_registry_dp02_backups_point_in_time_recovery_enabled = false

# Science Platform Database
science_platform_db_maintenance_window_day  = 2
science_platform_db_maintenance_window_hour = 22
science_platform_backups_enabled            = true

# Increase this number to force Terraform to update the int environment.
# Serial: 9
