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

variable "ingest_gcs_storage_class" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = string
  default     = "STANDARD"
}

variable "ingest_gcs_versioning" {
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

variable "promote_chunks_cloud_run_min_instance_count" {
  description = "Minimum number of cloud run instances"
  default     = 0
  type        = number
}
variable "promote_chunks_cloud_run_max_instance_count" {
  description = "Maximum number of cloud run instances"
  default     = 1
  type        = number
}

variable "promote_chunks_cloud_run_concurrency" {
  description = "Max number of simultaneous requests for a single container instance"
  default     = 1
  type        = number
}

variable "promote_chunks_cloud_run_ppdb_config_uri" {
  description = "PPDB Config URI"
  type        = string
}

variable "promote_chunks_cloud_run_ppdb_use_secret_manager" {
  description = "Flag to use GCP Secret Manager"
  default     = false
  type        = bool

}

variable "promote_chunks_cloud_run_log_execution_id" {
  description = "Flag to log execution id"
  default     = true
  type        = bool

}

variable "promote_chunks_cloud_run_retry_policy" {
  description = "Cloud Run retry policy"
  default     = "RETRY_POLICY_DO_NOT_RETRY"
  type        = string
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

variable "promote_chunks_scheduler_min_backoff_duration" {
  description = "The maximum amount of time to wait before retrying a job after it fails."
  type        = string
  default     = "1s"
}

variable "promote_chunks_scheduler_max_retry_duration" {
  description = "The time limit for retrying a failed job, measured from time when an execution was first attempted. If specified with retryCount, the job will be retried until both limits are reached."
  type        = string
  default     = "10s"
}

variable "promote_chunks_scheduler_max_doublings" {
  description = "The time between retries will double maxDoublings times."
  type        = number
  default     = 2
}

variable "promote_chunks_scheduler_retry_count" {
  description = "The number of attempts that the system will make to run a job using the exponential backoff procedure described by maxDoublings"
  type        = number
  default     = 3
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


# Track Chunk Cloud Run

variable "track_chunk_cloud_run_min_instance_count" {
  description = "Minimium number of cloud run instances"
  default     = 0
  type        = number
}

variable "track_chunk_cloud_run_max_instance_count" {
  description = "Minimium number of cloud run instances"
  default     = 100
  type        = number
}

variable "track_chunk_cloud_run_concurrency" {
  description = "Max number of simultaneous requests for a single container instance"
  default     = 1
  type        = number
}

variable "track_chunk_cloud_run_ppdb_config_uri" {
  description = "PPDB Config URI"
  type        = string
}

variable "track_chunk_cloud_run_ppdb_use_secret_manager" {
  description = "Flag to use GCP Secret Manager"
  default     = false
  type        = bool
}

variable "track_chunk_runtime" {
  description = "Runtime for Cloud Run Functions"
  type        = string
}

variable "track_chunk_cloud_run_retry_policy" {
  description = "Cloud Run retry policy"
  default     = "RETRY_POLICY_DO_NOT_RETRY"
  type        = string
}

variable "track_chunk_db_name" {
  description = "CloudSQL Database name"
  default     = "ppdb"
  type        = string
}

# Trigger Stage Chunk Cloud Run

variable "trigger_stage_chunk_cloud_run_min_instance_count" {
  description = "Minimum number of cloud run instances"
  default     = 0
  type        = number
}

variable "trigger_stage_chunk_cloud_run_max_instance_count" {
  description = "Maximum number of cloud run instances"
  default     = 100
  type        = number
}

variable "trigger_stage_chunk_cloud_run_concurrency" {
  description = "Max number of simultaneous requests for a single container instance"
  default     = 1
  type        = number
}

variable "trigger_stage_chunk_cloud_run_dataflow_template_path" {
  description = "Dataflow Template Path"
  type        = string
}

variable "trigger_stage_chunk_cloud_run_log_level" {
  description = "Log Level"
  default     = "INFO"
  type        = string
}

variable "trigger_stage_chunk_cloud_run_log_execution_id" {
  description = "Flag to log execution id"
  default     = true
  type        = bool
}

variable "trigger_stage_chunk_cloud_run_temp_location" {
  description = "Temp location"
  type        = string
}

variable "trigger_stage_chunk_runtime" {
  description = "Runtime for Cloud Run Functions"
  type        = string
}

# GitHub CI

variable "create_gh_ci_sa" {
  description = "Create GitHub CI Test Service Account"
  type        = bool
  default     = false
}
