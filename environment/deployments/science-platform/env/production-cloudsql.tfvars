# Project
environment      = "stable"
application_name = "science-platform"
project_id       = "science-platform-stable-6994"

# Butler database
butler_db_name        = "butler-registry"
butler_tier           = "db-custom-2-13312"
butler_require_ssl    = false
butler_database_flags = [
  {name = "temp_file_limit", value = 2147483647},
  {name = "password_encryption", value = "scram-sha-256"}
]

# General database
db_maintenance_window_day  = 4
db_maintenance_window_hour = 22
backups_enabled            = true

