# Cloud SQL
environment      = "dev"
application_name = "ppdb"

# Butler Registry DP02 Database
ppdb_cloud_sql_db_tier                                = "db-custom-2-7680"
ppdb_cloud_sql_db_maintenance_window_day              = 1
ppdb_cloud_sql_db_maintenance_window_hour             = 23
ppdb_cloud_sql_db_maintenance_window_update_track     = "stable"
ppdb_cloud_sql_backups_enabled                        = false
ppdb_cloud_sql_backups_point_in_time_recovery_enabled = false

ppdb_cloud_sql_edition = "ENTERPRISE_PLUS"

# If you didn't make any other changes to this file, increase this number to
# force Terraform to update this environment. You may need to do this if you
# changed .tf files in this environment, or if you changed any modules that
# this environment uses, but you didn't change any variables in this file.
# Serial: 2
