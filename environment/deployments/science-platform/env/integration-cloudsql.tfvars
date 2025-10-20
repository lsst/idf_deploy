# Project
environment      = "int"
application_name = "science-platform"
project_id       = "science-platform-int-dc5d"

# Butler Registry DP02 Database
butler_registry_dp02_db_name                                = "butler-registry-dp02-int"
butler_registry_dp02_tier                                   = "db-custom-2-7680"
butler_registry_dp02_db_maintenance_window_day              = 2
butler_registry_dp02_db_maintenance_window_hour             = 23
butler_registry_dp02_db_maintenance_window_update_track     = "stable"
butler_registry_dp02_backups_enabled                        = false
butler_registry_dp02_backups_point_in_time_recovery_enabled = false

# Butler Registry DP1 Database
butler_registry_dp1_enabled         = true
butler_registry_dp1_tier            = "db-custom-2-7680"
butler_registry_dp1_backups_enabled = false

# Butler DP0.2/DP1 AlloyDB
butler_registry_alloydb_enabled = true

# Prompt data products AlloyDB
butler_prompt_data_products_enabled = true

# Science Platform Database
science_platform_db_maintenance_window_day  = 2
science_platform_db_maintenance_window_hour = 22
science_platform_backups_enabled            = true

# Increase this number to force Terraform to update the int environment.
# Serial: 24
