# Project
environment      = "dev"
application_name = "science-platform"
project_id       = "science-platform-dev-7696"

# Butler Registry DP02 Database
butler_registry_dp02_db_name                                = "butler-registry-dp02-dev"
butler_registry_dp02_tier                                   = "db-custom-2-7680"
butler_registry_dp02_db_maintenance_window_day              = 1
butler_registry_dp02_db_maintenance_window_hour             = 23
butler_registry_dp02_db_maintenance_window_update_track     = "stable"
butler_registry_dp02_backups_enabled                        = false
butler_registry_dp02_backups_point_in_time_recovery_enabled = false

# Butler Registry DP1 Database
butler_registry_dp1_enabled         = true
butler_registry_dp1_tier            = "db-custom-2-7680"
butler_registry_dp1_backups_enabled = false

# Science Platform Database
science_platform_db_maintenance_window_day          = 1
science_platform_db_maintenance_window_hour         = 22
science_platform_db_maintenance_window_update_track = "canary"
science_platform_backups_enabled                    = true

# Increase this number to force Terraform to update the dev environment.
# Serial: 34
