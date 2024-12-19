# Project
environment      = "stable"
application_name = "science-platform"
project_id       = "science-platform-stable-6994"

# Butler Registry Original Database
butler_registry_db_name          = "butler-registry"
butler_registry_database_version = "POSTGRES_13"
butler_registry_require_ssl      = false
butler_registry_tier             = "db-custom-4-26624"
butler_registry_database_flags = [
  { name = "temp_file_limit", value = 2147483647 },
  { name = "password_encryption", value = "scram-sha-256" },
  { name = "max_connections", value = 400 }
]

# Butler Registry DP02
butler_registry_dp02_enable = false

butler_database_version = "POSTGRES_13"
butler_registry_ipv4_enabled                           = false
butler_registry_db_maintenance_window_update_track     = "canary"
butler_registry_backups_enabled                        = true
butler_registry_backups_point_in_time_recovery_enabled = true

# Science Platform Database
science_platform_db_maintenance_window_day  = 4
science_platform_db_maintenance_window_hour = 22
science_platform_backups_enabled            = true

# Increase this number to force Terraform to update the prod environment.
# Serial: 6
