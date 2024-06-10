# Project
environment      = "dev"
application_name = "science-platform"
project_id       = "science-platform-dev-7696"

# Butler database
butler_db_name     = "butler-registry-dev"
butler_require_ssl = false
butler_database_flags = [
  { name = "password_encryption", value = "scram-sha-256" }
]
butler_database_version = "POSTGRES_13"
butler_ipv4_enabled     = true

# General database
db_maintenance_window_day          = 1
db_maintenance_window_hour         = 22
db_maintenance_window_update_track = "canary"
backups_enabled                    = true

# Increase this number to force Terraform to update the dev environment.
# Serial: 14
