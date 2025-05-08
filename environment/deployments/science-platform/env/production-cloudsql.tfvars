# Project
environment      = "stable"
application_name = "science-platform"
project_id       = "science-platform-stable-6994"

# Butler Registry DP02 Database
butler_registry_dp02_db_name          = "butler-registry-dp02-prod"
butler_registry_dp02_tier             = "db-custom-4-26624"
butler_registry_dp02_db_maintenance_window_day              = 4
butler_registry_dp02_db_maintenance_window_hour             = 22
butler_registry_dp02_db_maintenance_window_update_track     = "stable"
butler_registry_dp02_backups_enabled                        = true
butler_registry_dp02_backups_point_in_time_recovery_enabled = true

# Butler Registry DP1 Database
butler_registry_dp1_enabled          = true
butler_registry_dp1_tier             = "db-custom-4-26624"
butler_registry_dp1_backups_enabled  = true

# Butler DP0.2/DP1 AlloyDB
butler_registry_alloydb_enabled = true

# Science Platform Database
science_platform_db_maintenance_window_day  = 4
science_platform_db_maintenance_window_hour = 22
science_platform_backups_enabled            = true

# Increase this number to force Terraform to update the prod environment.
# Serial: 10
