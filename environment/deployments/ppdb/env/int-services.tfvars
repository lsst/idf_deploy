# Cloud SQL
environment      = "int"
application_name = "ppdb"
state_bucket     = "lsst-terraform-state"

# Promote Chunks Cloud Run
promote_chunks_cloud_run_ppdb_config_uri = "gs://ppdb-int-config/ppdb-int_config.yaml"
promote_chunks_schedule                  = "30 22 * * *"
promote_chunks_scheduler_timezone        = "Etc/UTC"

# Stage Chunk Cloud Run
stage_chunk_runtime = "python313"
stage_chunk_cloud_run_ppdb_config_uri = "gs://ppdb-int-config/ppdb-int_config.yaml"

# Load SSO Cloud Run
load_sso_runtime = "python313"
load_sso_cloud_run_ppdb_config_uri = "gs://ppdb-int-config/ppdb-int_config.yaml"

# Export DiaSource Min SSP Cloud Run
export_diasource_min_ssp_runtime = "python313"
export_diasource_min_ssp_cloud_run_ppdb_config_uri = "gs://ppdb-int-config/ppdb-int_config.yaml"

# BigQuery
bigquery_tap_extra_datasets = ["dp2_prompt"]

# If you didn't make any other changes to this file, increase this number to
# force Terraform to update this environment. You may need to do this if you
# changed .tf files in this environment, or if you changed any modules that
# this environment uses, but you didn't change any variables in this file.
# Serial: 15
