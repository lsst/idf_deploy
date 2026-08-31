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
