# Project
environment      = "demo"
application_name = "science-platform"
project_id       = "science-platform-demo-9e05"

# Butler database.
# Also just take defaults.
# butler_db_name     = "butler-registry-demo"
# butler_require_ssl = false
# butler_database_flags = [
#   { name = "password_encryption", value = "scram-sha-256" }
# ]
# butler_database_version = "POSTGRES_13"
# butler_ipv4_enabled     = true

# General database
# Just take defaults.
# science_platform_db_maintenance_window_day          = 1
# science_platform_db_maintenance_window_hour         = 22

# Increase this number to force Terraform to update the demo environment.
# Serial: 5

science_platform_db_additional_databases = []
