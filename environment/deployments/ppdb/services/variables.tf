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

// BigQuery

variable "bigquery_max_time_travel_hours" {
  description = "Defines the time travel window in hours. The value can be from 48 to 168 hours (2 to 7 days)"
  type        = string
  default     = "168"
}

// Cloud Storage

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

variable "promote_chunks_cloud_run_timeout" {
  description = "Max time execution can take"
  default     = "900s"
  type        = string
}

variable "promote_chunks_cloud_run_concurrency" {
  description = "Max number of simultaneous requests for a single container instance"
  default     = 1
  type        = number
}

variable "promote_chunks_cloud_run_cpu_limit" {
  description = "CPU limit"
  default     = 2
  type        = number
}

variable "promote_chunks_cloud_run_memory_limit" {
  description = "Memory limit"
  default     = "4Gi"
  type        = string
}

variable "promote_chunks_cloud_run_ppdb_config_uri" {
  description = "PPDB Config URI"
  type        = string
}

variable "promote_chunks_cloud_run_ppdb_use_secret_manager" {
  description = "Flag to use GCP Secret Manager"
  default     = true
  type        = bool

}

variable "promote_chunks_cloud_run_log_execution_id" {
  description = "Flag to log execution id"
  default     = true
  type        = bool

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

variable "track_chunk_cloud_run_timeout" {
  description = "Max time execution can take"
  default     = "60s"
  type        = string
}

variable "track_chunk_cloud_run_concurrency" {
  description = "Max number of simultaneous requests for a single container instance"
  default     = 1
  type        = number
}

variable "track_chunk_cloud_run_cpu_limit" {
  description = "CPU limit"
  default     = 2
  type        = number
}

variable "track_chunk_cloud_run_memory_limit" {
  description = "Memory limit"
  default     = "4Gi"
  type        = string
}

variable "track_chunk_cloud_run_ppdb_config_uri" {
  description = "PPDB Config URI"
  type        = string
}

variable "track_chunk_cloud_run_ppdb_use_secret_manager" {
  description = "Flag to use GCP Secret Manager"
  default     = true
  type        = bool

}

variable "track_chunk_cloud_run_log_execution_id" {
  description = "Flag to log execution id"
  default     = true
  type        = bool

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

variable "trigger_stage_chunk_cloud_run_timeout" {
  description = "Max time execution can take"
  default     = "900s"
  type        = string
}

variable "trigger_stage_chunk_cloud_run_concurrency" {
  description = "Max number of simultaneous requests for a single container instance"
  default     = 1
  type        = number
}

variable "trigger_stage_chunk_cloud_run_cpu_limit" {
  description = "CPU limit"
  default     = 1
  type        = number
}

variable "trigger_stage_chunk_cloud_run_memory_limit" {
  description = "Memory limit"
  default     = "256Mi"
  type        = string
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
