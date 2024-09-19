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

// Butler Registry Originally Deployed with Google Cloud

variable "butler_registry_db_name" {
  description = "The name of the SQL Database instance"
}

variable "butler_registry_database_version" {
  description = "The database version to use for the Butler registry"
  type        = string
  default     = "POSTGRES_16"
}

variable "butler_registry_tier" {
  description = "The tier for the instance."
  type        = string
  default     = "db-f1-micro"
}

variable "butler_registry_database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "butler_registry_disk_type" {
  description = "The disk type for the master instance."
  type        = string
  default     = "PD_SSD"
}

variable "butler_registry_require_ssl" {
  description = "True if the instance should require SSL/TLS for users connecting over IP. Note: SSL/TLS is needed to provide security when you connect to Cloud SQL using IP addresses. If you are connecting to your instance only by using the Cloud SQL Proxy or the Java Socket Library, you do not need to configure your instance to use SSL/TLS."
  type        = bool
  default     = true
}

variable "butler_registry_ipv4_enabled" {
  type        = bool
  description = "True if enabling public IP on database"
  default     = false
}

variable "butler_registry_database_tier" {
  description = "The tier for general database"
  type        = string
  default     = "db-g1-small"
}

variable "butler_registry_db_maintenance_window_day" {
  type        = number
  description = "The day of week (1-7) for the master instance maintenance."
  default     = 1
}

variable "butler_registry_db_maintenance_window_hour" {
  type        = number
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  default     = 23
}

variable "butler_registry_db_maintenance_window_update_track" {
  type        = string
  description = "The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`."
  default     = "stable"
}

variable "butler_registry_backups_enabled" {
  type        = bool
  description = "True if backup configuration is enabled"
  default     = false
}

variable "butler_registry_backups_start_time" {
  type        = string
  description = "Start time for backups"
  default     = "09:00"
}

variable "butler_registry_backups_point_in_time_recovery_enabled" {
  type        = bool
  description = "Enable Point in Time Recovery for backups"
  default     = true
}

// Butler Registry DP02 Database variables

variable "butler_registry_dp02_db_name" {
  description = "The name of the SQL Database instance"
}

variable "butler_registry_dp02_database_version" {
  description = "The database version to use for the Butler registry"
  type        = string
  default     = "POSTGRES_16"
}

variable "butler_registry_dp02_tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-f1-micro"
}

variable "butler_registry_dp02_database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "butler_registry_dp02_disk_size" {
  description = "The disk size for the instance in GB.  This value is ignored after initial provisioning with a terraform lifecycle policy in Google module.  This is needed because of auto storage increase is enabled."
  type        = number
}

variable "butler_registry_dp02_disk_type" {
  description = "The disk type for the instance."
  type        = string
  default     = "PD_SSD"
}

variable "butler_registry_dp02_edition" {
  description = "The edition of the Cloud SQL instance, can be ENTERPRISE or ENTERPRISE_PLUS."
  type        = string
}


variable "butler_registry_dp02_require_ssl" {
  description = "True if the instance should require SSL/TLS for users connecting over IP. Note: SSL/TLS is needed to provide security when you connect to Cloud SQL using IP addresses. If you are connecting to your instance only by using the Cloud SQL Proxy or the Java Socket Library, you do not need to configure your instance to use SSL/TLS."
  type        = bool
  default     = true
}

variable "butler_registry_dp02_ipv4_enabled" {
  type        = bool
  description = "True if enabling public IP on database"
  default     = false
}

variable "butler_registry_dp02_ssl_mode" {
  description = "Specify how SSL connection should be enforced in DB connections.  Options are ALLOW_UNENCRYPTED_AND_ENCRYPTED, ENCRYPTED_ONLY, and TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
  type        = string
}

variable "butler_registry_dp02_database_tier" {
  description = "The tier for general database"
  type        = string
  default     = "db-g1-small"
}

variable "butler_registry_dp02_db_maintenance_window_day" {
  type        = number
  description = "The day of week (1-7) for the instance maintenance."
  default     = 1
}

variable "butler_registry_dp02_db_maintenance_window_hour" {
  type        = number
  description = "The hour of day (0-23) maintenance window for the instance maintenance."
  default     = 23
}

variable "butler_registry_dp02_db_maintenance_window_update_track" {
  type        = string
  description = "The update track of maintenance window for the instance maintenance. Can be either `canary` or `stable`."
  default     = "stable"
}

variable "butler_registry_dp02_backups_enabled" {
  type        = bool
  description = "True if backup configuration is enabled"
  default     = false
}

variable "butler_registry_dp02_backups_start_time" {
  type        = string
  description = "Start time for backups"
  default     = "09:00"
}

variable "butler_registry_dp02_backups_point_in_time_recovery_enabled" {
  type        = bool
  description = "Enable Point in Time Recovery for backups"
  default     = true
}

// Science Platform Database variables

variable "science_platform_database_version" {
  description = "The database version to use for the Science Platform"
  type        = string
  default     = "POSTGRES_13"
}

variable "science_platform_database_tier" {
  description = "The tier for general database"
  type        = string
  default     = "db-g1-small"
}

variable "science_platform_db_maintenance_window_day" {
  type        = number
  description = "The day of week (1-7) for the instance maintenance."
  default     = 1
}

variable "science_platform_db_maintenance_window_hour" {
  type        = number
  description = "The hour of day (0-23) maintenance window for the instance maintenance."
  default     = 23
}

variable "science_platform_db_maintenance_window_update_track" {
  type        = string
  description = "The update track of maintenance window for the instance maintenance. Can be either `canary` or `stable`."
  default     = "stable"
}

variable "science_platform_backups_enabled" {
  type        = bool
  description = "True if backup configuration is enabled"
  default     = false
}

variable "science_platform_backups_start_time" {
  type        = string
  description = "Start time for backups"
  default     = "09:00"
}
