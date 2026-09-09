# Cloud SQL
environment      = "prod"
application_name = "usdf-backups"
state_bucket     = "lsst-terraform-state"

# Transfer Job
apdb_source_bucket          = "usdf-apdb-prod"
apdb_backup_prefixes        = ["medusa_backup_apdb_prod"]
apdb_backup_start_time_hour = "20"

# If you didn't make any other changes to this file, increase this number to
# force Terraform to update this environment. You may need to do this if you
# changed .tf files in this environment, or if you changed any modules that
# this environment uses, but you didn't change any variables in this file.
# Serial: 6
