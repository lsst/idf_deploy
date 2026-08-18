# Cloud SQL
environment      = "int"
application_name = "ppdb"
state_bucket     = "lsst-terraform-state"

# Promote Chunks Cloud Run
promote_chunks_cloud_run_ppdb_config_uri = "gs://ppdb-int-config/ppdb_int.yaml"
promote_chunks_runtime = "python313"

# Track Chunk Cloud Run
track_chunk_cloud_run_ppdb_config_uri = "gs://ppdb-int-config/ppdb_int.yaml"
track_chunk_runtime = "python313"

# Trigger Stage Chunks Cloud Run
trigger_stage_chunk_cloud_run_dataflow_template_path = "gs://ppdb-int-dataflow/templates/stage_chunk_flex_template.json"
trigger_stage_chunk_cloud_run_temp_location = "gs://ppdb-int-dataflow/temp"
trigger_stage_chunk_runtime = "python313"

# GitHub CI
create_gh_ci_sa = true

# If you didn't make any other changes to this file, increase this number to
# force Terraform to update this environment. You may need to do this if you
# changed .tf files in this environment, or if you changed any modules that
# this environment uses, but you didn't change any variables in this file.
# Serial: 9
