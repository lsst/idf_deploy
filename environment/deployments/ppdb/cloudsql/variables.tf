
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

variable "ppdb_cloud_sql_database_version" {
  description = "The database version to use for the PPDB PostgreSQL database"
  type        = string
  default     = "POSTGRES_18"
}

variable "ppdb_cloud_sql_tier" {
  description = "The tier for the database."
  type        = string
  default     = "db-custom-2-16384"
}

variable "ppdb_cloud_sql_database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = [{
    name  = "cloudsql.iam_authentication"
    value = "on"
    }
  ]
}

variable "ppdb_cloud_sql_disk_size" {
  description = "The disk size for the instance in GB.  This value is ignored after initial provisioning with a terraform lifecycle policy in Google module.  This is needed because of auto storage increase is enabled."
  type        = number
  default     = 700
}

variable "ppdb_cloud_sql_disk_type" {
  description = "The disk type for the instance."
  type        = string
  default     = "PD_SSD"
}

variable "ppdb_cloud_sql_edition" {
  description = "The edition of the Cloud SQL instance, can be ENTERPRISE or ENTERPRISE_PLUS."
  type        = string
  default     = "ENTERPRISE"
}


variable "ppdb_cloud_sql_require_ssl" {
  description = "True if the instance should require SSL/TLS for users connecting over IP. Note: SSL/TLS is needed to provide security when you connect to Cloud SQL using IP addresses. If you are connecting to your instance only by using the Cloud SQL Proxy or the Java Socket Library, you do not need to configure your instance to use SSL/TLS."
  type        = bool
  default     = false
}

variable "ppdb_cloud_sql_ipv4_enabled" {
  type        = bool
  description = "True if enabling public IP on database"
  default     = false
}

variable "ppdb_cloud_sql_enable_private_path" {
  description = "Direct services to use the private path for connectivity to CloudSQL"
  type        = bool
  default     = false
}

variable "ppdb_cloud_sql_authorized_networks" {
  default     = []
  type        = list(map(string))
  description = "List of mapped public networks authorized to access to the instances."
}

variable "ppdb_cloud_sql_ssl_mode" {
  description = "Specify how SSL connection should be enforced in DB connections.  Options are ALLOW_UNENCRYPTED_AND_ENCRYPTED, ENCRYPTED_ONLY, and TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
  type        = string
  default     = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
}

variable "ppdb_cloud_sql_database_tier" {
  description = "The tier for general database"
  type        = string
  default     = "db-g1-small"
}

variable "ppdb_cloud_sql_data_cache_enabled" {
  description = "Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE_PLUS tier and supported database_versions"
  type        = bool
  default     = false
}

variable "ppdb_cloud_sql_db_maintenance_window_day" {
  type        = number
  description = "The day of week (1-7) for the instance maintenance."
  default     = 1
}

variable "ppdb_cloud_sql_db_maintenance_window_hour" {
  type        = number
  description = "The hour of day (0-23) maintenance window for the instance maintenance."
  default     = 23
}

variable "ppdb_cloud_sql_db_maintenance_window_update_track" {
  type        = string
  description = "The update track of maintenance window for the instance maintenance. Can be either `canary` or `stable`."
  default     = "stable"
}

variable "ppdb_cloud_sql_backups_enabled" {
  type        = bool
  description = "True if backup configuration is enabled"
  default     = false
}

variable "ppdb_cloud_sql_backups_start_time" {
  type        = string
  description = "Start time for backups"
  default     = "09:00"
}

variable "ppdb_cloud_sql_backups_point_in_time_recovery_enabled" {
  type        = bool
  description = "Enable Point in Time Recovery for backups"
  default     = true
}
