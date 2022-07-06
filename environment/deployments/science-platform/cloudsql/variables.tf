variable "application_name" {
  description = "The name of application where GCP resources relate"
  type        = string
}

variable "environment" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which resources will be provisioned."
  type        = string
}

variable "network" {
  description = "Name of the VPC"
  type        = string
  default     = "custom-vpc"
}

variable "butler_db_name" {
  description = "The name of the SQL Database instance"
  default     = "example-postgresql-public"
}

variable "butler_database_version" {
  description = "The database version to use for the Butler registry"
  type        = string
  default     = "POSTGRES_12"
}

variable "butler_tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-f1-micro"
}

variable "butler_database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "butler_require_ssl" {
  description = "True if the instance should require SSL/TLS for users connecting over IP. Note: SSL/TLS is needed to provide security when you connect to Cloud SQL using IP addresses. If you are connecting to your instance only by using the Cloud SQL Proxy or the Java Socket Library, you do not need to configure your instance to use SSL/TLS."
  type        = bool
  default     = true
}

variable "butler_ipv4_enabled" {
  type        = bool
  description = "True if enabling public IP on database"
  default     = false
}

variable "database_tier" {
  description = "The tier for general database"
  type        = string
  default     = "db-g1-small"
}

variable "database_version" {
  description = "The database version to use for the general database"
  type        = string
  default     = "POSTGRES_13"
}

variable "db_maintenance_window_day" {
  type        = number
  description = "The day of week (1-7) for the master instance maintenance."
  default     = 1
}

variable "db_maintenance_window_hour" {
  type        = number
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  default     = 23
}

variable "db_maintenance_window_update_track" {
  type        = string
  description = "The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`."
  default     = "stable"
}

variable "backups_enabled" {
  type        = bool
  description = "True if backup configuration is enabled"
  default     = false
}

variable "butler_service_account" {
  description = "Service account used for Butler GCS access"
  type        = string
  default     = "butler-gcs-butler-gcs-data-sa@data-curation-prod-fbdb.iam.gserviceaccount.com"
}

variable "maximum_cutouts_age" {
  description = "Age of objects in days before deletion from the temporary cutouts bucket"
  type        = number
  default     = 30
}
