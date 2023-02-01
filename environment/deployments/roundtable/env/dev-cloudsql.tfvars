# Project
environment      = "dev"
application_name = "roundtable"
project_id       = "roundtable-dev-abe2"

# General database
db_maintenance_window_day          = 1
db_maintenance_window_hour         = 22
db_maintenance_window_update_track = "canary"
backups_enabled                    = true

# Increase this number to force Terraform to update the dev environment.
# Serial: 1
