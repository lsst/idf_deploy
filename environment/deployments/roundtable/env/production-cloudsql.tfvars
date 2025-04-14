# Project
environment      = "prod"
application_name = "roundtable"
project_id       = "roundtable-prod-f6fd"

# General database
db_maintenance_window_day  = 4
db_maintenance_window_hour = 22
backups_enabled            = true

# Temporarily override the database version until we can get back in sync
# with roundtable-dev.
database_version = "POSTGRES_14"

# Increase this number to force Terraform to update the prod environment.
# Serial: 6
