# Cloud SQL
environment      = "prod"
application_name = "ppdb"
state_bucket     = "lsst-terraform-state"

# Promote Chunks Cloud Run
promote_chunks_cloud_run_ppdb_config_uri = "gs://ppdb-prod-config/ppdb-prod_config.yaml"

# Track Chunk Cloud Run
track_chunk_cloud_run_ppdb_config_uri = "gs://ppdb-prod-config/ppdb-prod_config.yaml"
track_chunk_runtime = "python313"

# Trigger Stage Chunks Cloud Run
trigger_stage_chunk_cloud_run_dataflow_template_path = "gs://ppdb-prod-dataflow/templates/stage_chunk_flex_template.json"
trigger_stage_chunk_cloud_run_temp_location = "gs://ppdb-prod-dataflow/temp"
trigger_stage_chunk_runtime = "python313"

# Load SSO Cloud Run
load_sso_cloud_run_dataflow_template_path = "gs://ppdb-prod-dataflow/templates/load_sso_flex_template.json"
load_sso_cloud_run_temp_location = "gs://ppdb-prod-dataflow/temp"
load_sso_runtime = "python313"

# GitHub CI
create_gh_ci_sa = true

# Remote state
rsp_remote_state_env = "stable"

# If you didn't make any other changes to this file, increase this number to
# force Terraform to update this environment. You may need to do this if you
# changed .tf files in this environment, or if you changed any modules that
# this environment uses, but you didn't change any variables in this file.
# Serial: 1
