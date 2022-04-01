# Project
environment      = "int"
application_name = "science-platform"
project_id       = "science-platform-int-dc5d"

# Butler database
butler_db_name = "butler-registry-int"
butler_require_ssl    = false
butler_database_flags = [
  {name = "temp_file_limit", value = 1049000000},
  {name = "password_encryption", value = "scram-sha-256"}
]

# General database
db_maintenance_window_day  = 2
db_maintenance_window_hour = 22
backups_enabled            = true

# Increase this number to force Terraform to update the int environment.
# Serial: 4

