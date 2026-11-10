variable "state_bucket" {
  type        = string
  description = "The GCS bucket name for terraform state"
}

variable "application_name" {
  description = "The name of application where GCP resources relate"
  type        = string
}

variable "environment" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "region" {
  description = "The GCP region to run resources"
  type        = string
  default     = "us-central1"
}

# BigQuery

variable "bigquery_max_time_travel_hours" {
  description = "Defines the time travel window in hours. The value can be from 48 to 168 hours (2 to 7 days)"
  type        = string
  default     = "168"
}

variable "bigquery_landing_table_expiration_days" {
  description = "Number of days before a table in the landing dataset is deleted"
  type        = number
  default     = 1
}

variable "bigquery_tap_extra_datasets" {
  description = "Additional BigQuery datasets, not managed by this configuration, that the TAP service account can read"
  type        = list(string)
  default     = []
}

# Cloud Storage

variable "config_gcs_storage_class" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = string
  default     = "STANDARD"
}

variable "config_gcs_versioning" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = bool
  default     = false
}

variable "dataflow_gcs_storage_class" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = string
  default     = "STANDARD"
}

variable "dataflow_gcs_versioning" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = bool
  default     = false
}

variable "export_gcs_storage_class" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = string
  default     = "STANDARD"
}

variable "export_gcs_versioning" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = bool
  default     = false
}

variable "chunk_ingest_gcs_storage_class" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = string
  default     = "STANDARD"
}

variable "chunk_ingest_gcs_versioning" {
  description = "Whether object versioning is enabled on the chunk ingest bucket"
  type        = bool
  default     = false
}

variable "sso_ingest_gcs_storage_class" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = string
  default     = "STANDARD"
}

variable "sso_ingest_gcs_versioning" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = bool
  default     = false
}

# Artifact Registry

variable "ppdb_repo_image_keep_count" {
  description = "The amount of container images to retain"
  default     = 5
  type        = number
}

# Promote Chunks Cloud Run

variable "promote_chunks_cloud_run_ppdb_config_uri" {
  description = "PPDB Config URI"
  type        = string
}

variable "promote_chunks_cloud_run_ppdb_use_secret_manager" {
  description = "Flag to use GCP Secret Manager"
  default     = false
  type        = bool

}

variable "promote_chunks_schedule" {
  description = "Cron time for Cloud Scheduler to schedule Promote Chunks to run"
  type        = string
  default     = "0 12 * * *"
}

variable "promote_chunks_scheduler_timezone" {
  description = "Timezone for Promote Chunks scheduler"
  type        = string
  default     = "America/Santiago"
}

variable "promote_chunks_scheduler_attempt_deadline" {
  description = "The deadline for job attempts"
  type        = string
  default     = "180s"
}

variable "promote_chunks_cloud_run_cpu_limit" {
  description = "CPU limit"
  default     = 4
  type        = number
}

variable "promote_chunks_cloud_run_memory_limit" {
  description = "Memory limit"
  default     = "16Gi"
  type        = string
}

variable "promote_chunks_db_name" {
  description = "CloudSQL Database name"
  default     = "ppdb"
  type        = string
}

variable "promote_chunks_cloud_run_execution_environment" {
  description = "Cloud Run execution environment"
  default     = "EXECUTION_ENVIRONMENT_GEN2"
  type        = string
}

variable "promote_chunks_timeout" {
  description = "Promote Chunks timeout"
  default     = "7200s"
  type        = string
}

# Stage Chunk Cloud Run

variable "stage_chunk_cloud_run_min_instance_count" {
  description = "Minimum number of cloud run instances, kept running to avoid cold starts"
  default     = 1
  type        = number
}

variable "stage_chunk_cloud_run_max_instance_count" {
  description = "Maximum number of cloud run instances"
  default     = 100
  type        = number
}

variable "stage_chunk_cloud_run_concurrency" {
  description = "Max number of simultaneous requests for a single container instance"
  default     = 1
  type        = number
}

variable "stage_chunk_cloud_run_log_level" {
  description = "Log Level"
  default     = "INFO"
  type        = string
}

variable "stage_chunk_cloud_run_log_execution_id" {
  description = "Flag to log execution id"
  default     = true
  type        = bool
}

variable "stage_chunk_bigquery_check_timeout_seconds" {
  description = "Limit in seconds on the stage chunk function's query that checks the staging tables for a chunk's rows"
  default     = 60
  type        = number
}

variable "stage_chunk_bigquery_job_timeout_seconds" {
  description = "Limit in seconds on each load job and on the transaction run by the stage chunk function"
  default     = 240
  type        = number
}

variable "stage_chunk_bigquery_retry_timeout_seconds" {
  description = "Limit in seconds on how long the stage chunk function retries each BigQuery API request after a temporary error"
  default     = 300
  type        = number
}

variable "stage_chunk_cloud_run_ppdb_config_uri" {
  description = "PPDB Config URI"
  type        = string
}

variable "stage_chunk_db_name" {
  description = "CloudSQL Database name"
  default     = "ppdb"
  type        = string
}

variable "stage_chunk_runtime" {
  description = "Runtime for Cloud Run Functions"
  type        = string
}

# Load SSO Cloud Run

variable "load_sso_cloud_run_min_instance_count" {
  description = "Minimum number of cloud run instances"
  default     = 0
  type        = number
}

variable "load_sso_cloud_run_max_instance_count" {
  description = "Maximum number of cloud run instances"
  default     = 1
  type        = number
}

variable "load_sso_cloud_run_concurrency" {
  description = "Max number of simultaneous requests for a single container instance"
  default     = 1
  type        = number
}

variable "load_sso_cloud_run_dataflow_template_path" {
  description = "Dataflow Template Path"
  type        = string
}

variable "load_sso_cloud_run_dataflow_machine_type" {
  description = "Dataflow worker machine type"
  default     = "n1-highmem-2"
  type        = string
}

variable "load_sso_cloud_run_log_level" {
  description = "Log Level"
  default     = "INFO"
  type        = string
}

variable "load_sso_cloud_run_log_execution_id" {
  description = "Flag to log execution id"
  default     = true
  type        = bool
}

variable "load_sso_num_retries" {
  description = "Number of retries for Dataflow flex template launch requests"
  default     = 5
  type        = number
}

variable "load_sso_cloud_run_temp_location" {
  description = "Temp location"
  type        = string
}

variable "load_sso_staging_dataset_id" {
  description = "BigQuery dataset ID for staging tables written before the swap into the internal dataset"
  default     = "ppdb_staging"
  type        = string
}

variable "load_sso_internal_dataset_id" {
  description = "BigQuery dataset ID for the internal tables that staging tables are swapped into"
  default     = "ppdb_internal"
  type        = string
}

variable "load_sso_runtime" {
  description = "Runtime for Cloud Run Functions"
  type        = string
}

# Pub/Sub

variable "stage_chunk_pubsub_max_delivery_attempts" {
  description = "Failed push deliveries to the stage chunk function before a message is sent to its dead-letter topic (5 to 100)"
  type        = number
  default     = 100
}

variable "load_sso_pubsub_max_delivery_attempts" {
  description = "Failed push deliveries to the load SSO function before a message is sent to its dead-letter topic (5 to 100)"
  type        = number
  default     = 15
}

# Remote state

variable "rsp_remote_state_env" {
  description = "The name of the environment in the RSP remote state key, if it is different than the name of the environment in this ppdb services state key."
  type        = string
  default     = null
}

# GitHub CI

variable "create_gh_ci_sa" {
  description = "Create GitHub CI Test Service Account"
  type        = bool
  default     = false
}
