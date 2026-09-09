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

# APDB

variable "apdb_backup_location" {
  description = "The Storage Class of the apdb backups bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = string
  default     = "us-central1"
}

variable "apdb_backup_gcs_storage_class" {
  description = "The Storage Class of the apdb backups bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  type        = string
  default     = "STANDARD"
}

variable "apdb_backup_object_versioning_enabled" {
  description = "Enable GCS object versioning for APDB Backups"
  type        = bool
  default     = true
}

variable "apdb_backup_object_versioning_retention_time" {
  description = "Retention time in days for GCS object versions"
  type        = number
  default     = 14
}

variable "apdb_backup_gcs_autosclass_enabled" {
  description = "Enable GCS Autoclass for APDB Backups"
  type        = bool
  default     = true
}

variable "apdb_backup_gcs_autosclass_tier" {
  description = "Tier for GCS autoclass"
  type        = string
  default     = "ARCHIVE"
}

# Storage Transfer Job

variable "apdb_storage_transfer_enabled" {
  description = "Enabled status of APDB storage transfer job"
  type        = string
  default     = "ENABLED"
}

variable "apdb_source_bucket" {
  description = "Source bucket for copying backup files"
  type        = string
}

variable "apdb_source_bucket_s3_endpoint" {
  description = "Source bucket endpoint for copying backup files"
  type        = string
  default     = "https://s3dfrgw.slac.stanford.edu"
}

variable "apdb_source_bucket_auth_method" {
  description = "Auth method for source bucket"
  type        = string
  default     = "AUTH_METHOD_AWS_SIGNATURE_V4"
}

variable "apdb_source_bucket_request_method" {
  description = "Request method for source bucket"
  type        = string
  default     = "REQUEST_MODEL_PATH_STYLE"
}

variable "apdb_backup_prefixes" {
  description = "Directory path prefixes to include for copying backups"
  type        = list(string)
}

variable "apdb_transfer_options_overwrite_when" {
  description = "When to overwrite objects that already exist in the sink.  Possible values: ALWAYS, DIFFERENT, NEVER."
  type        = string
  default     = "DIFFERENT"
}

variable "apdb_transfer_options_delete_objects_unique_in_sink" {
  description = "Whether objects that exist only in the sink should be deleted"
  type        = bool
  default     = true
}

variable "apdb_backup_start_year" {
  description = "Year to start scheduled APDB copy of backups"
  type        = string
  default     = "2026"
}

variable "apdb_backup_start_month" {
  description = "Month to start scheduled APDB copy of backups"
  type        = string
  default     = "9"
}

variable "apdb_backup_start_day" {
  description = "Day to start scheduled APDB copy of backups"
  type        = string
  default     = "9"
}

variable "apdb_backup_start_time_hour" {
  description = "Start time hour in UTC"
  type        = string
}

variable "apdb_transfer_job_repeat_interval" {
  description = "Interval between the start of each scheduled transfer. If unspecified, the default value is 24 hours. This value may not be less than 1 hour."
  type        = string
  default     = "86400s"
}